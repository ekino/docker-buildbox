Versions
========

2020-01-DEV
-----------

* Add mysql-client in PHP images
* Migrate CI to GitHub Actions

2019-12-26
-----------

* Upgrade the React Native image to Node 12.13 and NPM to 6.12.0
* Remove Watchman, some exposed ports and the custom user from the React Native image
* Fix a typo in the `nightly` tag name
* Upgrade Java 8 to 8u232 and 11 to 11.0.5
* Upgrade Serverless base image to use node:10-alpine3.10 (python 3.7 support)
* Add PHP image version 7.4.0
* Upgrade PHP version: 7.2.25 and 7.3.12
* Upgrade APCu version: 5.1.18
* Upgrade Composer version: 1.9.1
* Upgrade php-cs-fixer version: 2.16.1
* Upgrade Redis version: 5.1.1
* Upgrade Security Checker version: 6.0.3
* Upgrade XDEBUG version: 2.8.0
* Add mysqli in PHP images
* Upgrade Golang version: 1.13.5
* Remove Subversion and Mercurial from the Java images
* Upgrade Docker Compose: 1.25.0
* Upgrade platform.sh CLI: 3.50.1
* Upgrade Terraform: 0.12.18
* Upgrade ScoutSuite: 5.5
* Upgrade Serverless: 1.59.3
* Add eksctl to the kubectl image
* Update Kubectl version (and associated tools) : 1.16

2019-11-18
-----------

* Fix Chrome image build
* Upgrade Golang version: 1.13.4
* Upgrade Serverless version: 1.57
* Upgrade PHP version: 7.2.23 / 7.3.10
* Upgrade memcached version: 3.1.4
* Upgrade ssh2 version: 1.2
* Upgrade Debian to 10.1 for Node images
* Upgrade Node 12 image to 12.13 and NPM to 6.12.0
* Upgrade Scoutsuite version: 5.4.0
* Add Node & Npm to AWS image, in order to build & deploy AWS CDK

2019-09-19
----------

* CI: lock Python version to 2.7
* Add gettext in dind-aws and PHP images
* Fix build error in Chrome
* Upgrade Java versions: 8u222, 11.0.4
* Lock scss_lint version to fix issue with Ruby version
* Upgrade Node version: 6.17.1, 8.16.0
* Upgrade NVM version: 0.34.0
* Add a new image PHP version 7.3
* Add patch in PHP images
* Upgrade PHP version: 7.2.22
* Upgrade redis version extension: 5.0.2
* Upgrade security checker version: 6.0.2
* Upgrade PHP CS Fixer: 2.15.3
* Upgrade Composer version: 1.9.0
* Upgrade Xdebug version: 2.7.2
* Upgrade Ruby version: 2.6.3
* Remove support for PHP 7.1
* Fix Java 8/11 image issues from debian:stretch-slim
* Drop JDK 10 support
* Migrate Java buildboxes to adoptopenjdk
* AWS image now uses python3
* Add new dockerfile "terraform" version 0.12.0
* Fix Golang version for accurate image tag
* Add a new image integrating NCC Scoutsuite
* Change Ansible base image for python:2.7-alpine3.8
* Refacto travis.py script, setup image definitions within a single configuration file
* Upgrade Jinja to 2.10.1
* Add a new image integrating node Serverless and python3
* Add AmazonLinux image with Systemd
* Add a new image with kubectl & other k8s tools
* Add Platform.sh CLI image
* Upgrade Python: 2.7.16, 3.7.4
* Use only major Node version to name node images
* Add Node 12
* Upgrade ScoutSuite to 5.3.3
* Create image with azure CLI and terraform
* Upgrade Golang version: 1.13
* Upgrade Serverless version: 1.51
* Add aws-cli in serverless image
* Core: change config file structure to allow volume mounting for local test scripts
* Core: fix docker login & push in debug mode
* Core: upgrade docker-py lib from 3.5.0 to 4.0.2
* Remove support for Node 6
* Add Kubeval to Kubectl images
* Remove support for JDK 6

2019-04-05
----------

* Force PyYAML version to 3.13 in aws image
* Added jq in aws image

2019-03-29
----------

* Lock rb-inotify version to fix issue with Ruby version
* Upgrade Java versions: 8u181, 10.0.2, 11.0.1
* Downgrade Maven version to 3.2.1 for Java 6 buildbox (Maven 3.2.3+ uses HTTPS by default)
* Upgrade Golang version: 1.11
* Added awsebcli to AWS buildbox
* Remove support for PHP 5.6
* Upgrade PHP version: 7.1.27, 7.2.16
* Upgrade APCu version: 5.1.17
* Upgrade Composer version: 1.8.4
* Upgrade memcached version: 3.1.3
* Upgrade Redis version: 4.3.0
* Upgrade Sensiolabs' security-checker version: 5.0.3
* Upgrade Xdebug version: 2.7.0
* Fix repository of gnu-libiconv for PHP images
* Remove php7-intl
* Added graphviz and jq to Java buildbox
* Fix debian sources list for Node buildbox
* Upgrade Docker version to 18.06.3 and Docker Compose to 1.24.0 in dind-aws image
* Upgrade Node version: 6.17.0, 8.15.1, 10.15.3
* Upgrade Python version: 3.7.3
* Upgrade Sonar version: 3.3.0.1492

2018-10-29
----------

* Add anchorecli in Python 2
* Remove support for PHP 5.3
* Add Java version 11
* Add Arachni image version 1.5.1
* Update Sonar download URL
* Upgrade ci-helper: 0.0.6
* Add Blackfire probe & client in PHP images
* Use openjdk slim as base Java image
* Add Java version 10.0.1
* Add Java version 6 (with only JDK and Maven 3.2.1)
* Use openjdk slim as base React Native image
* Remove Maven and Gradle from React Native image
* Add bash to Python images
* Add an up to date mime types definition file for the images that use AWS CLI
* Install PEAR in the PHP 5.3 image
* Update Alpine Version for ansible, aws and sonar image: 3.8
* Add `build-base`, `libffi-dev` and `openldap-dev` packages in Python images
* Upgrade Pip version in Python images
* Update dind-aws to use 18.06.1-ce-dind
* Fix ansible build (move from python 2.7.14-r0 to 2.7.15-r1)
* Java image : fix aws failed when removing pip
* Upgrade Maven version : 3.2.5
* Upgrade APCu version for PHP 7.1 and 7.2: 5.1.12
* Upgrade Composer version for PHP 7.1 and 7.2: 1.7.2
* Upgrade PHP version: 5.6.38, 7.1.23, 7.2.11
* Upgrade Redis version for PHP 7.1 and 7.2: 4.1.1
* Upgrade Xdebug version for PHP 7.1 and 7.2: 2.6.1
* Fix install of intl extension in PHP images
* Upgrade Node version: 8.12, 10.12
* Upgrade NPM version for Node 8.12 and 10.10: 6.4.1
* Upgrade NVM version: 0.33.11
* Upgrade Python version: 3.7
* Add a Chrome image (based on Alpine Node, with NPM, Yarn and Puppeteer)
* Fix pip version to 18 and pipenv to 2018.7.1 to avoid recent conflict between these tools
* Add dependencies for cpython libs in dind-aws image
* Add `memcached`, `pgsql` and `ssh2` extensions in PHP images

2018-06-14
----------

* Add rsync in PHP images
* Add exif extension in PHP images
* Add PHP 7.2.6
* Upgrade PHP version: 7.1.18
* Upgrade Node version: 6.14.3, 8.11.3, 10.4.1
* Upgrade Sonar Scanner: 3.2.0.1227
* Upgrade ci-helper: 0.0.5

2018-05-18
----------

* Upgrade Docker version to 18.05.0 and Docker Compose to 1.21.2 in dind-aws image
* Upgrade Node version: 6.14.2, 8.11.2, 9.11.1
* Upgrade PHP version: 5.6.36, 7.1.17
* Upgrade Composer version: 1.6.5
* Upgrade PHP Redis version: 4.0.2
* Upgrade Ruby version: 2.5.1
* Add Python images: versions 2.7 and 3.6
* Add tests on PHP images
* Add React Native image
* Upgrade Java version: 8u171-1\~webupd8\~0
* Fix intl in PHP images

2018-04-05
----------

* Upgrade Python version in Ansible image: 2.7.14-r0
* Upgrade Docker version to 18.03.0 and Docker Compose to 1.20.1 in dind-aws image
* Upgrade Node version: 6.14.1, 8.11.1, 9.10.1
* Upgrade PHP version: 5.6.35, 7.1.16
* Upgrade APCu version for PHP 7.1: 5.1.11
* Upgrade Composer version: 1.6.3
* Upgrade PHP Redis version: 4.0.0
* Upgrade Sensiolabs' security-checker version for PHP 7: 4.1.8
* Upgrade Xdebug version for PHP 7: 2.6.0
* Use Alpine binary of ci-helper for Ansible, AWS, DIND-AWS, PHP >= 5.6, Ruby and Sonar images
* Fix deprecated MAINTAINER instruction
* BC break: PHP image is now based on Alpine
    - intl for PHP 7.2 is not released yet, so image 7.2 is not available anymore
* Upgrade modd version: 0.5

2018-01-25
----------

* Upgrade NPM version in Node image (fix node@9 incompatibility):
    - node v8.9.4  -> npm v5.6.0
    - node v9.4.0  -> npm v5.6.0
* Upgrade ci-helper version: 0.0.4
* Upgrade Docker version to 18.01.0 and Docker Compose to 1.18.0 in dind-aws image
* Upgrade Java version: 8u161-1\~webupd8\~0
* Upgrade Node version: 6.12.3, 8.9.4, 9.4.0
* Upgrade APCu version: 5.1.9
* Upgrade Composer version: 1.6.2
* Upgrade PHP Redis version: 3.1.6
* Upgrade Sensiolabs' security-checker version for PHP 7: 4.1.7
* Upgrade PHP version: 5.6.33, 7.2.1
* Upgrade Ruby version: 2.5.0
* Add rsync to aws image
* Add zip to aws image
* Add postgresql-client to PHP image

2017-12-12
----------

* Add tzdata into sonar image
* Upgrade Ruby version: 2.4.2
* Upgrade Glide version: 0.13.1
* Upgrade Docker Compose version: 1.17.1
* Upgrade Composer version: 1.5.5
* Upgrade PHP version: 5.6.32, 7.1.12
* Upgrade Node version: 6.12.2, 8.9.3, 9.2.1
* Allow specifying NPM version in Node image :
    - node v6.11.3 -> npm v3.10.10
    - node v8.9.1  -> npm v5.5.1
    - node v9.2.0  -> npm v5.5.1
* Add rsync and tzdata into dind-aws image
* Add Sensiolabs' security-checker to PHP images
* Add make to aws image

2017-11-01
----------

* BC break: dind-aws image is now based on Alpine
* Upgrade Docker version to 17.09 and Docker Compose to 1.16.1 in dind-aws image
* Upgrade Java version: 8u151-1\~webupd8\~0
* Upgrade PHP version: 5.6.31, 7.1.9
* Upgrade PHP Redis: 3.1.4
* Add Node 8.6
* Upgrade node 6.11.3
* Remove Node 4.8
* Upgrade golang: 1.9 (edit: wrong information, still version 1.8)
* Upgrade Glide: 0.13.0
* Add Ansible: 2.2.3.0
* Add Sonar Scanner: 3.0.3.778

2017-07-17
----------

* Upgrade PhpRedis: 3.1.3
* Add a "new" PHP image (5.3) for legacy support
* Upgrade Node version: 4.8.4, 6.11.1, 7.10.1
* Upgrade PHP version: 7.1.7
* Upgrade composer version: 1.4.2
* Upgrade the base Debian image: 8.7
* Upgrade Java version: 8u131
* Add imagemagick, gcc and g++ into Node image
* Add a new Ruby image
* Add composer hirak/prestissimo plugin
* Upgrade go version: 1.8

2017-03-30
----------

* Upgrade Java version: 8u121-1\~webupd8\~2
* Add PHP extension: intl
* Add bzip2 into Node, Java and PHP images
* Upgrade ci-helper to version 0.0.3 to support gitlab 9.x
* Update PHP version: 7.1.3
* Update Node version: 4.8.1, 6.10.1, 7.8.0

2017-02-07
----------

* Add PHP extension for Redis
* Add PHP version: 7.1.1
* Remove PHP version: 7.0.14
* Upgrade PHP version: 5.6.30
* Upgrade APCu version: 5.1.8
* Upgrade composer version: 1.3.2
* Upgrade Java version: 8u121
* Upgrade Maven version: 3.3.9
* Upgrade Node version: 4.7.3, 6.9.5, 7.5.0
* Add a new Golang image

2017-01-06
----------

* Add a new AWS image with awscli and python libs
* Add CI-Helper 0.0.2 into base image
* Add a new DIND AWS image with AWS Cli
* Add Modd 0.0.4 into base image
* Upgrade Node version: 4.7.2, 6.9.4, 7.4.0
* Upgrade PHP version: 5.6.29, 7.0.14
* Upgrade composer version: 1.3.0

2016.12-19
----------

* Slightly reduce the size of the Java image
* Add the AWS CLI to all images
* Add packages ocaml & libelf-dev for FlowType (Node) checking
* Upgrade Node versions: 4.7.0, 7.2.1
* Upgrade PHP: 7.0.14
* Fix Java Version to 8u111+8u111arm-1~webupd8~0
* Fix composer version to 1.2.4
* Migrate builds and tests to TravisCI, add support for nightly build
* Tweak PHP build configuration

2016.12.05
----------

* Fix maven install on Java
* Fix clean commands
* Update Yarn 0.18

2016.11.25
----------

* Use Debian 8.6 as base image
* Upgrade PHP versions: 5.6.28, 7.0.13
* Add driver pdo_pgsql in PHP images
* Add cache APCu in PHP images
* Upgrade Node versions: 4.6.2, 6.9.1 (LTS)
* Add Node 7.0.0
* Add maven to java8
* Remove global packages install from node: gulp, bower, grunt-cli, webpack, browserify, babel, eslint, eslint-plugin-react, eslint-plugin-angular, eslint-config-standard, eslint-plugin-promise, eslint-plugin-standard.
* Add Yarn to node
* Update nvm to 0.32.1

2016.09.16
----------

* Use Debian 8.5 as base image
* Upgrade PHP versions: 5.6.22, 7.0.10
* Remove node versions: 4.3, 6.0, 5.7
* Add node version: 6.5
* Upgrade node version: 4.5.0
* Updrade node tools: grunt-cli@1.2, webpack@1.13, estlint@2.13, eslint-plugin-react@5.2, eslint-plugin-angular@1.1, eslint-config-standard@5.3, eslint-plugin-promise@1.3 and eslint-plugin-standard@1.3.

2016.05.03
----------

* Bump versions 2016.05.03
* Node: 4.3.2, 4.4.3, 5.7.1, 6.0.0
* PHP: 5.6.20, 7.0.5

2016.05-DEV
-----------

* Add NodeJS 4.4 and 6.0.0, remove 0.12 image.
* Upgrade NodeJS versions: 4.3.2. 4.4.3, 5.7.1, 6.0.0
* Upgrade PHP versions: 5.6.20, 7.0.5
* Remove bashrc sourcing for NodeJS and PHP images.
* Use Debian 8.4 as base image

2016.03-DEV
-----------

* PHP
    - 7.0.3
    - 5.6.18
    - composer / php-cs-fixer

* NodeJs
    - 0.12.10
        - npm@2
        - gulp@3.9
        - bower@1.7
        - grunt-cli@0.1
        - webpack@1.12
        - browserify@13.0
        - babel@6.5
        - eslint@2.0
        - eslint-plugin-react@3.16
        - eslint-plugin-angular@0.15
        - eslint-config-standard@5.1
        - eslint-plugin-promise@1.0
        - eslint-plugin-standard@1.3

    - 4.3.0
        - npm@3
        - gulp@3.9
        - bower@1.7
        - grunt-cli@0.1
        - webpack@1.12
        - browserify@13.0
        - babel@6.5
        - eslint@2.0
        - eslint-plugin-react@3.16
        - eslint-plugin-angular@0.15
        - eslint-config-standard@5.1
        - eslint-plugin-promise@1.0
        - eslint-plugin-standard@1.3

    - 5.7.0
        - npm@3
        - gulp@3.9
        - bower@1.7
        - grunt-cli@0.1
        - webpack@1.12
        - browserify@13.0
        - babel@6.5
        - eslint@2.0
        - eslint-plugin-react@3.16
        - eslint-plugin-angular@0.15
        - eslint-config-standard@5.1
        - eslint-plugin-promise@1.0
        - eslint-plugin-standard@1.3

2014.15-DEV
-----------

GitlabCi can handle an image per job. So there is no need to have an all-in-one image.

PHP Images:

- php5.6
- php7.0

NodeJs Images:

- node0.12
- node4.3
- node5.7
