import json
import os
import re
import urllib.error
import urllib.request

from src.docker_tools import retry_with_backoff

API_ROOT = "https://api.github.com/repos"
USER_AGENT = "ekino-docker-buildbox"


class TransientApiError(Exception):
    """A GitHub API failure worth retrying: timeout, 5xx, secondary rate limit."""


class VersionResolutionError(Exception):
    """A tool version could not be resolved, and retrying would not help."""


class AuthRefused(VersionResolutionError):
    """GitHub refused the authenticated request, but may still serve it anonymously."""


def _auth_header():
    """The Authorization header to send, as a (name, value) pair, or None.

    CI provides GH_AUTH_HEADER because anonymous callers get only 60 requests
    per hour, which a full matrix build used to exhaust. Local builds without it
    simply stay anonymous. An empty token - what a fork pull request gets, since
    secrets are not exposed to it - counts as no header at all, rather than
    guaranteeing a 401.
    """
    header = os.environ.get("GH_AUTH_HEADER", "").strip()
    name, _, value = header.partition(":")
    value = value.strip()
    if not name or value in ("", "Bearer", "token"):
        return None
    return name.strip(), value


@retry_with_backoff(exceptions=(TransientApiError,))
def _get(url, authenticated):
    header = _auth_header() if authenticated else None
    request = urllib.request.Request(url, headers={
        "Accept": "application/vnd.github+json",
        "User-Agent": USER_AGENT,
    })
    if header:
        request.add_header(*header)
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            return json.load(response)
    except urllib.error.HTTPError as http_error:
        raise _explain(url, http_error, authenticated) from http_error
    except (urllib.error.URLError, TimeoutError) as url_error:
        raise TransientApiError(f"{url}: {url_error}") from url_error


def _explain(url, http_error, authenticated):
    """Turn an HTTP error into the exception that says what to do about it."""
    mode = "authenticated" if authenticated else "anonymous"
    context = f"{url} returned HTTP {http_error.code} ({mode} request)"

    if http_error.code >= 500:
        return TransientApiError(context)

    if http_error.code in (403, 429):
        # A secondary rate limit comes with the delay to honour, and going
        # anonymous does not help - the limit is per caller, not per credential.
        retry_after = http_error.headers.get("retry-after")
        if retry_after:
            return TransientApiError(f"{context} - secondary rate limit, retry-after {retry_after}s")

        exhausted = http_error.headers.get("x-ratelimit-remaining") == "0"
        reset = http_error.headers.get("x-ratelimit-reset")
        detail = f" - rate limit exhausted, resets at {reset}" if exhausted else ""
        if authenticated:
            # Not necessarily a rate limit: some orgs (aquasecurity, for one)
            # enable an IP allow list that refuses authenticated requests from CI
            # runners while still serving the same public data anonymously. The
            # anonymous quota is separate, so it is worth a try either way.
            return AuthRefused(f"{context}{detail}")
        return VersionResolutionError(f"{context}{detail}")

    if http_error.code == 404:
        return VersionResolutionError(
            f"{context} - the repository was renamed or removed, or the token cannot see it"
        )

    return VersionResolutionError(context)


# Responses for the lifetime of the process. Resolving the whole matrix in one
# go asks four images for Helm and five for Trivy, which was 45 requests where
# 33 distinct URLs would do. Caching is not merely an optimisation here: every
# image in a run must be handed the same answer for the same tool, and a cache
# makes that true by construction rather than by the releases not moving.
_response_cache = {}


def _fetch(path):
    url = f"{API_ROOT}/{path}"
    if url in _response_cache:
        return _response_cache[url]
    if _auth_header() is None:
        response = _get(url, authenticated=False)
    else:
        try:
            response = _get(url, authenticated=True)
        except AuthRefused as refused:
            print(f"> [Warning] {refused} - retrying anonymously")
            response = _get(url, authenticated=False)
    _response_cache[url] = response
    return response


def _latest_tag(repo):
    tag = _fetch(f"{repo}/releases/latest").get("tag_name", "")
    if not tag:
        raise VersionResolutionError(f"{repo}: the latest release has no tag_name")
    return tag


def _released_tags(repo):
    releases = _fetch(f"{repo}/releases?per_page=100")
    return [
        release.get("tag_name", "") for release in releases
        if not release.get("prerelease") and not release.get("draft")
    ]


def _strip_prefix(repo, tag, pattern):
    match = re.match(pattern, tag)
    if not match:
        raise VersionResolutionError(f"{repo}: tag {tag!r} does not match {pattern!r}")
    return match.group(1)


def _latest(repo, image_version):
    """The latest release, without its leading v: v1.2.3 -> 1.2.3."""
    return _strip_prefix(repo, _latest_tag(repo), r"^v?(.+)$")


def _latest_tag_as_is(repo, image_version):
    """The latest release tag verbatim, for projects that tag without a v."""
    return _latest_tag(repo)


def _kustomize(repo, image_version):
    """Kustomize shares a repository with other tools and tags kustomize/vX.Y.Z."""
    return _strip_prefix(repo, _latest_tag(repo), r"^kustomize/v(.+)$")


def _latest_v3(repo, image_version):
    """The latest 3.x.y release, for Helm, whose 2.x line is still tagged."""
    for tag in _released_tags(repo):
        if re.match(r"^v3\.\d+\.\d+$", tag):
            return tag[1:]
    raise VersionResolutionError(f"{repo}: no v3.x.y release found")


def _highest_with_prefix(repo, image_version):
    """The highest release whose tag starts with the image version.

    The Sonar scanner tags 8.1.0.1234, and the 8.1 image wants the newest of
    those - which is not necessarily the newest release overall.
    """
    def parts(tag):
        return [int(part) for part in tag.split(".")]

    candidates = [
        tag for tag in _released_tags(repo)
        if tag.startswith(f"{image_version}.") and re.match(r"^[\d.]+$", tag)
    ]
    if not candidates:
        raise VersionResolutionError(f"{repo}: no release tagged {image_version}.*")
    return max(candidates, key=parts)


RULES = {
    "latest": _latest,
    "latest_tag": _latest_tag_as_is,
    "kustomize": _kustomize,
    "latest_v3": _latest_v3,
    "highest_with_prefix": _highest_with_prefix,
}


def _parse_spec(build_arg, spec):
    """Read one github_versions entry: either 'owner/repo' or {repo:, rule:}."""
    if isinstance(spec, str):
        repo, rule = spec, "latest"
    else:
        repo, rule = spec.get("repo"), spec.get("rule", "latest")
    if not repo:
        raise VersionResolutionError(f"{build_arg}: no repo configured")
    if rule not in RULES:
        raise VersionResolutionError(
            f"{build_arg}: unknown rule {rule!r} - known rules are {', '.join(sorted(RULES))}"
        )
    return repo, rule


def resolve(github_versions, image_version):
    """Resolve the tool versions a Dockerfile expects to be passed as build args.

    The Dockerfiles used to do this themselves, once per architecture and once
    per build, which meant a full matrix build spent 172 requests against a
    60/hour anonymous limit and could tag the pushed image with different
    versions than the tested one. Resolving here spends one request per tool and
    pins both builds to the same answers.
    """
    build_args = {}
    for build_arg, spec in sorted(github_versions.items()):
        repo, rule = _parse_spec(build_arg, spec)
        build_args[build_arg] = RULES[rule](repo, image_version)
        print(f"> [Info] {build_arg}={build_args[build_arg]} (from {repo})")
    return build_args
