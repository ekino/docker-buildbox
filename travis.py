import os, subprocess, sys


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


if not os.environ.get('LANGUAGE', False) or not os.environ.get('VERSION', False):
    print "please provide a LANGUAGE and a VERSION env variable"
    sys.exit(1)

ci_helper_version = os.environ.get("CI_HELPER_VERSION", "0.0.2")

commit_range = os.environ.get('TRAVIS_COMMIT_RANGE', "HEAD...HEAD").replace("...", "..")
files = subprocess.Popen("git diff --name-only %s | sort | uniq" % commit_range, stdout=subprocess.PIPE, shell=True).stdout.read()
language = os.environ.get("LANGUAGE")
version = os.environ.get("VERSION")
base_image = "%s%s" % (language, version)

if language in ["aws", "dind-aws"]:
    base_image = language

is_tag = False
is_pr = False
is_release = False
is_master = False
start_build = False
push_image = False

print "TRAVIS_BRANCH=%s" % os.environ.get('TRAVIS_BRANCH', False)
print "TRAVIS_TAG=%s" % os.environ.get('TRAVIS_TAG', False)
print "TRAVIS_PULL_REQUEST=%s" % os.environ.get('TRAVIS_PULL_REQUEST', False)
print "LANGUAGE=%s" % language
print "VERSION=%s" % version
print "CI_HELPER_VERSION=%s" % ci_helper_version
print "TRAVIS_COMMIT_RANGE=%s" % commit_range

print "BASE IMAGE: %s" % base_image
print "MODIFIED FILES: %s" % files

if os.environ.get('TRAVIS_PULL_REQUEST') != "false":
    print " > This is a PR"
    is_pr = True

if len(os.environ.get('TRAVIS_TAG', "")) > 0:
    print " > This is a Tag"
    is_tag = True
    image = "ekino/docker-buildbox:%s-%s" % (base_image, os.environ.get('TRAVIS_TAG'))
    start_build = True  # on tag build all images
    push_image = True
elif os.environ.get('TRAVIS_BRANCH') == 'master' and not is_pr:
    print " > This is a master commit"
    is_master = True
    image = "ekino/docker-buildbox:latest-%s" % (base_image)
else:
    image = base_image

if os.environ.get('TRAVIS_EVENT_TYPE') == "cron":
    print " > This is a cron event"
    image = "ekino/docker-buildbox:nightly-%s" % (base_image)
    start_build = True
    push_image = True

if is_pr and is_tag:
    print "cannot be a tag and a pr"
    sys.exit(1)

if (is_pr or is_master) and language in files:
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
    run_args = "--rm"
    if language == "php":
        build_args = "%s --build-arg PHP_VERSION=%s --build-arg PHP_BUILD_INSTALL_EXTENSION=%s" % (build_args, os.environ.get("PHP_VERSION"), os.environ.get("PHP_BUILD_INSTALL_EXTENSION"))

    if language == "java":
        build_args = "%s --build-arg JAVA_VERSION=%s" % (build_args, os.environ.get("JAVA_VERSION"))

    if language == "node":
        build_args = "%s --build-arg NODE_VERSION=%s" % (build_args, os.environ.get("NODE_VERSION"))

    if language == "dind-aws":
        run_args = "%s --privileged" % run_args

    cmd = "docker build -t %s %s --no-cache %s" % (image, build_args, language)

    print "> Run: %s" % cmd

    run_command_exit(cmd, "fail to build the image")

    run_command_exit("docker run %s %s ci-helper version -e" % (run_args, image), "Error with ci-helper installation")

    if language == "php":
        print "> Testing PHP Image ...."
        run_command_exit("docker run %s %s php --version" % (run_args, image), "Error with php check")
        run_command_exit("docker run %s %s composer --version" % (run_args, image), "Error with composer check")

    if language == "java":
        print "> Testing Java Image ...."
        run_command_exit("docker run %s %s java -version" % (run_args, image), "Error with java check")
        run_command_exit("docker run %s %s mvn --version" % (run_args, image), "Error with mvn check")

    if language == "node":
        print "> Testing Node Image ...."
        run_command_exit("docker run %s %s node --version" % (run_args, image), "Error with node check")
        run_command_exit("docker run %s %s npm --version" % (run_args, image), "Error with npm check")
        run_command_exit("docker run %s %s sass --version" % (run_args, image), "Error with sass check")

    if language == "aws":
        print "> Testing AWS Image ...."
        run_command_exit("docker run %s %s aws --version" % (run_args, image), "Error with awscli check")
        run_command_exit("docker run %s %s python -c \"import boto3\"" % (run_args, image), "Error with boto3 check")
        run_command_exit("docker run %s %s python -c \"import yaml\"" % (run_args, image), "Error with PyYAML check")

    if language == "dind-aws":
        print "> Testing DIND - AWS Image ...."
        run_command_exit("docker run %s %s aws --version" % (run_args, image), "Error with awscli check")
        run_command_exit("docker run %s %s docker --version" % (run_args, image), "Error with docker check (should be installed by gitlab/dind image)")
        run_command_exit("docker run %s %s docker-compose --version" % (run_args, image), "Error with docker-compose check (should be installed by gitlab/dind image)")

if push_image:
    run_command_exit("docker login --username %s --password %s" % (os.environ.get('DOCKER_USERNAME'), os.environ.get('DOCKER_PASSWORD')), "unable to login to docker")
    run_command_exit("docker push %s" % image, "unable to login to docker")
