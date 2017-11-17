import os, subprocess, sys, argparse
import collections

BuildInfo = collections.namedtuple('BuildInfo', 'language version ci_helper_version commit_range branch tag pull_request event_type is_travis modd')

def main():
    parser = argparse.ArgumentParser(description='Build some docker images.')
    parser.add_argument('--language', dest='language', default=os.environ.get('LANGUAGE'), help='The language/image to build')
    parser.add_argument('--version', dest='version', default=os.environ.get('VERSION'), help='The language\'s version to build')
    parser.add_argument('--ci-helper-version', dest='ci_helper_version', default=os.environ.get('CI_HELPER_VERSION', '0.0.3'), help='the ci helper version')
    parser.add_argument('--commit-range', dest='commit_range', default=os.environ.get('TRAVIS_COMMIT_RANGE', 'HEAD...HEAD'), help='the commit range')
    parser.add_argument('--branch', dest='branch', default=os.environ.get('TRAVIS_BRANCH', ""), help='the commit branch')
    parser.add_argument('--tag', dest='tag', default=os.environ.get('TRAVIS_TAG', False), help='the commit tag')
    parser.add_argument('--pull-request', dest='pull_request', default=os.environ.get('TRAVIS_PULL_REQUEST', "false"), help='it is a PR?')
    parser.add_argument('--event-type', dest='event_type', default=os.environ.get('TRAVIS_EVENT_TYPE', ""), help='The event type which trigger the build')
    parser.add_argument('--travis', dest='travis', default=os.environ.get('TRAVIS', "false"), help='is travis')
    parser.add_argument('--modd', dest='modd', default='0.4', help='is travis')

    args = parser.parse_args()

    buildInfo = BuildInfo(
        language=args.language,
        version=args.version,
        ci_helper_version=args.ci_helper_version,
        commit_range=args.commit_range,
        branch=args.branch if len(args.branch) > 0 else False,
        tag=args.tag,
        pull_request=True if args.pull_request != "false" else False,
        event_type=args.event_type,
        is_travis=True if args.travis == "true" else False,
        modd=args.modd,
    )

    print args, buildInfo

    run_build(buildInfo)

def run_command_exit(command, exit_message):
    if run_command(command) != 0:
        print exit_message
        sys.exit(1)


def run_command(command):
    process = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
    while True:
        output = process.stdout.readline()
        if output == '' and process.poll() is not None:
            break
        if output:
            print output.strip()

    rc = process.poll()

    return rc


def run_build(buildInfo):
    if not buildInfo.language or not buildInfo.version:
        print "please provide a LANGUAGE and a VERSION"
        sys.exit(1)

    commit_range = buildInfo.commit_range.replace("...", "..")
    print "git diff --name-only %s | sort | uniq" % commit_range

    files = subprocess.Popen("git diff --name-only %s | sort | uniq" % commit_range, stdout=subprocess.PIPE, shell=True).stdout.read()
    language = buildInfo.language
    version = buildInfo.version
    ci_helper_version = buildInfo.ci_helper_version
    base_image = "%s%s" % (language, version)

    if language in ["aws", "dind-aws"]:
        base_image = language

    is_tag = False
    is_pr = False
    is_release = False
    is_master = False
    start_build = False
    push_image = False

    print "TRAVIS_BRANCH=%s" % buildInfo.branch
    print "TRAVIS_TAG=%s" % buildInfo.tag
    print "TRAVIS_PULL_REQUEST=%s" % buildInfo.pull_request
    print "LANGUAGE=%s" % language
    print "VERSION=%s" % version
    print "CI_HELPER_VERSION=%s" % buildInfo.ci_helper_version
    print "TRAVIS_COMMIT_RANGE=%s" % commit_range

    print "BASE IMAGE: %s" % base_image
    print "MODIFIED FILES: %s" % files

    if buildInfo.pull_request:
        print " > This is a PR"
        is_pr = True

    if buildInfo.tag:
        print " > This is a Tag"
        is_tag = True
        image = "ekino/docker-buildbox:%s-%s" % (base_image, buildInfo.tag)
        start_build = True  # on tag build all images
        push_image = True
    elif buildInfo.branch == 'master' and not is_pr:
        print " > This is a master commit"
        is_master = True
        image = "ekino/docker-buildbox:latest-%s" % (base_image)
    else:
        image = base_image

    if buildInfo.event_type == "cron":
        print " > This is a cron event"
        image = "ekino/docker-buildbox:nightly-%s" % (base_image)
        start_build = True
        push_image = True

    if is_pr and is_tag:
        print "cannot be a tag and a pr"
        sys.exit(1)

    if (is_pr or is_master) and (not buildInfo.is_travis or language in files or ".travis.yml" in files):
        start_build = True
        push_image = is_master

    print "is_pr: %s" % is_pr
    print "is_tag: %s" % is_tag
    print "is_master: %s" % is_master
    print "is_release: %s" % is_release
    print "image: %s" % image
    print "start_build: %s" % start_build
    print "push_image: %s" % push_image

    if start_build:
        build_args = "--build-arg CI_HELPER_VERSION=%s" % ci_helper_version
        build_context = language
        run_args = "--rm"
        if language == "php":
            build_args = "%s --build-arg MODD_VERSION=%s --build-arg PHP_VERSION=%s --build-arg PHP_BUILD_INSTALL_EXTENSION=%s --build-arg REDIS_VERSION=%s --build-arg SECURITY_CHECKER_VERSION=%s" % (build_args, buildInfo.modd, os.environ.get("PHP_VERSION"), os.environ.get("PHP_BUILD_INSTALL_EXTENSION"), os.environ.get("REDIS_VERSION"), os.environ.get("SECURITY_CHECKER_VERSION"))
            if version == "5.3":
                build_context = "%s/%s" % (language, version)

        if language == "java":
            build_args = "%s --build-arg MODD_VERSION=%s --build-arg JAVA_VERSION=%s" % (build_args, buildInfo.modd, os.environ.get("JAVA_VERSION"))

        if language == "node":
            build_args = "%s --build-arg MODD_VERSION=%s --build-arg NODE_VERSION=%s" % (build_args, buildInfo.modd, os.environ.get("NODE_VERSION"))

        if language == "golang":
            build_args = "%s --build-arg MODD_VERSION=%s --build-arg GLIDE_VERSION=%s" % (build_args, buildInfo.modd, os.environ.get("GLIDE_VERSION"))

        if language == "dind-aws":
            build_args = "%s --build-arg DOCKER_VERSION=%s --build-arg DOCKER_COMPOSE_VERSION=%s" % (build_args, os.environ.get("DOCKER_VERSION"), os.environ.get("DOCKER_COMPOSE_VERSION"))

        if language == "ansible":
            build_args = "%s --build-arg VERSION=%s --build-arg PYTHON_VERSION=%s --build-arg GLIBC_VERSION=%s" % (build_args, buildInfo.version, os.environ.get("PYTHON_VERSION"), os.environ.get("GLIBC_VERSION"))

        if language == "sonar":
            build_args = "%s --build-arg SONARSCANNER_VERSION=%s" % (build_args, os.environ.get("SONARSCANNER_VERSION"))

        cmd = "docker build -t %s %s --no-cache %s" % (image, build_args, build_context)

        print "> Run: %s" % cmd

        run_command_exit(cmd, "fail to build the image")

        run_command_exit("docker run %s %s ci-helper version -e" % (run_args, image), "Error with ci-helper installation")

        if language == "php":
            print "> Testing PHP Image..."
            run_command_exit("docker run %s %s php --version" % (run_args, image), "Error with php check")
            run_command_exit("docker run %s %s composer --version" % (run_args, image), "Error with composer check")
            run_command_exit("docker run %s %s modd --version" % (run_args, image), "Error with modd check")
            run_command_exit("docker run %s %s security-checker --version" % (run_args, image), "Error with security-checker check")

        if language == "java":
            print "> Testing Java Image..."
            run_command_exit("docker run %s %s java -version" % (run_args, image), "Error with java check")
            run_command_exit("docker run %s %s mvn --version" % (run_args, image), "Error with mvn check")
            run_command_exit("docker run %s %s modd --version" % (run_args, image), "Error with modd check")

        if language == "node":
            print "> Testing Node Image..."
            run_command_exit("docker run %s %s node --version" % (run_args, image), "Error with node check")
            run_command_exit("docker run %s %s npm --version" % (run_args, image), "Error with npm check")
            run_command_exit("docker run %s %s sass --version" % (run_args, image), "Error with sass check")
            run_command_exit("docker run %s %s modd --version" % (run_args, image), "Error with modd check")

        if language == "aws":
            print "> Testing AWS Image..."
            run_command_exit("docker run %s %s aws --version" % (run_args, image), "Error with awscli check")
            run_command_exit("docker run %s %s python -c \"import boto3\"" % (run_args, image), "Error with boto3 check")
            run_command_exit("docker run %s %s python -c \"import yaml\"" % (run_args, image), "Error with PyYAML check")

        if language == "dind-aws":
            print "> Testing DIND - AWS Image..."
            run_command_exit("docker run %s %s aws --version" % (run_args, image), "Error with awscli check")
            run_command_exit("docker run %s %s docker --version" % (run_args, image), "Error with docker check (should be installed by docker image)")
            run_command_exit("docker run %s %s docker-compose --version" % (run_args, image), "Error with docker-compose check (should be installed by dind-aws image)")
            run_command_exit("docker run --privileged -d --name %s %s" % (language, image), "Error on starting dind-aws container")
            run_command_exit("docker exec %s docker ps" % (language), "Error with docker ps check")
            run_command_exit("docker rm -f %s" % (language), "Error on removing dind-aws container")

        if language == "golang":
            print "> Testing Golang Image..."
            run_command_exit("docker run %s %s aws --version" % (run_args, image),   "Error with awscli check")
            run_command_exit("docker run %s %s go version" % (run_args, image),      "Error with go check")
            run_command_exit("docker run %s %s glide --version" % (run_args, image), "Error with glide check")
            run_command_exit("docker run %s %s gin --version" % (run_args, image),   "Error with gin check")
            run_command_exit("docker run %s %s modd --version" % (run_args, image),  "Error with modd check")

        if language == "ruby":
            print "> Testing Ruby Image..."
            run_command_exit("docker run %s %s ruby --version" % (run_args, image),   "Error with ruby check")
            run_command_exit("docker run %s %s bundle --version" % (run_args, image), "Error with bundle check")

        if language == "ansible":
            print "> Testing Ansible Image..."
            run_command_exit("docker run %s %s ansible --version" % (run_args, image),   "Error with ansible check")
            run_command_exit("docker run %s %s ansible-playbook --version" % (run_args, image), "Error with ansible-playbook check")

        if language == "sonar":
            print "> Testing Sonar Scanner Image..."
            run_command_exit("docker run %s %s java -version" % (run_args, image),   "Error with java version")
            run_command_exit("docker run %s %s sonar-scanner -v" % (run_args, image), "Error with ansible-playbook check")


        print ""
        print "You can now test the image with the following command:\n   $ docker run --rm -ti %s" % image

    if push_image:
        run_command_exit("docker login --username %s --password %s" % (os.environ.get('DOCKER_USERNAME'), os.environ.get('DOCKER_PASSWORD')), "unable to login to docker")
        run_command_exit("docker push %s" % image, "unable to login to docker")


if __name__ == "__main__":
    main()