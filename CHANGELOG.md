Versions
========

2023-04-30
----------
* Ansible : dropping this image.
* AWS : adding yq, terraform, tfenv and associated tools. Removing boto3. Bumping misc tools' versions
* Azure : adding yq, terraform, tfenv and associated tools. Bumping misc tools' versions
* Terraform : dropping this image. Terraform tooling is now included directly in AWS & Azure images
* Golang : Bump Golang-ci-lint version

2023-03-31
----------
* Golang : Creating golang version 1.20
* PHP: update some packages versions

2023-02-28
----------
* AWS: switching from python 3.10 to 3.11
* Azure: switching from python 3.10 to 3.11
* Java: upgrade Java images
* Platform: switching from python 3.8 to 3.11

2023-01-31
----------
* Ansible: bumping from 5.x.x to 7.x.x
* Ansible: switching base image from debian buster to bullseye
* AWS: bumping kubectl, kustomize, helm, trivy versions
* AWS: switching base image from debian buster to bullseye
* Azure: bumping kubectl, kustomize, helm, trivy versions
* Azure: switching base image from debian buster to bullseye
* Cloudsploit: switching base image from debian buster to bullseye
* Dind: bumping kubectl, kustomize, helm, trivy versions
* PHP: adding support for php 8.2 and removing for 7.4. Php-cs-fixer isn't officially supported in 8.2 as of now, use it with care.
* Platform: switching to the new 4.x.x Golang CLI
* Platform: build arm64 docker image
* Pynode: switching base image from debian buster to bullseye
* Python: switching base image from debian buster to bullseye
* Terraform: switching base image from debian buster to bullseye
* Terraform: bumping to TF 1.3.x. Updating terragrunt & infracost
* Tezosqa: switching base image from debian buster to bullseye

2022-12-31
----------
* Node: Adding jq command
* Python : adding support for python 3.11

2022-11-30
----------
* AWS : Adding kubectl & associated tools
* AWS : removing taskfile, kube-no-trouble and kube-score
* Azure : Adding kubectl & associated tools
* Azure : always install the latest CLI
* Azure : removing taskfile, kube-no-trouble and kube-score
* Kubectl : removing this image, the tools are now included in AWS & Azure images
* PHP : build arm64 docker image
* Ruby : dropping support for this flavor

2022-10-31
----------
* Golang : Updating golangci-lint to 1.49.0 to handle go1.19 & go1.18

2022-09-30
----------
* Ansible : Build arm64 docker image
* Azure : build arm64 azure docker image
* Chrome : build arm64 docker image
* Cloudsploit : build arm64 docker image
* Golang : build arm64 docker image
* Golang : Remove testfixtures test. Binary does not exist for arch arm64
* Golang : Remove version 1.17. Image does not exist for arch arm64
* Golang : Updating Gitleaks to 8.11.2
* Golang : Updating Go-testfixtures to 3.8.0
* Golang : Updating Mockgen to 1.6
* Java : build arm64 docker image
* Node : build arm64 docker image
* Percy : build arm64 docker image

2022-08-31
----------

* AWS : Build arm64 docker image
* AWS : Fix tagging issue preventing the push of multiple architectures to docker hub
* Bitcoind : Build arm64 image
* Bitcoind : Updating to bitcoind to 23.0
* Golang: adding new 1.19 flavor
* Java: upgrade Java 11 to 11.0.16 and 17 to 17.0.4
* Platformsh: updating base image, and CLI to the latest 3.81.x

2022-07-31
----------

* PHP: updating tools
* Terraform: bump terraform to 1.2.5, along with associated tools
* Python SRC : Change python docker module from docker to python-on-whales
* Python SRC : Build amd64 images with docker buildx
* Python SRC Config : Add linux/amd64 and linux/arm64 as values for the new config property base_platforms
* CI : use docker/setup-qemu-action@v2 and docker/setup-buildx-action@v2 as gitflows step actions
* Images : Only [OCI images](https://github.com/opencontainers/image-spec/blob/main/spec.md) for amd64 architecture are built


2022-06-30
----------

No specific change this month, just standard dependencies updates. Happy summer !

2022-05-31
----------

* Chrome: removing ci-helper binary
* Dind: removing ci-helper binary
* Dind: changing docker-compose installation method to apk.
* Dind: bumping Trivy's version
* Golang: removing ci-helper binary
* Golang: golang 1.16 is now EOL, removing this image's flavor
* Java: removing ci-helper binary
* Node: removing ci-helper binary
* Node: adding new 18.x flavor
* PHP: removing ci-helper binary
* Ruby: removing ci-helper binary
* Sonar: removing ci-helper binary
* Sonar: updating to sonar-scanner-cli 4.7.x
* Kubectl: updating to 1.24, along with associated tools
* Kubectl: adding Trivy, which now supports scanning kubernetes resources
* Platformsh: updating to the latest 3.79.x CLI
* Terraform: bump terraform to 1.2.1, along with associated tools
* Terraform: adding Google Cloud CLI

2022-04-30
----------

* Tezosqa: Version 1.0 that use version 0.9.0 of smartpy
* expose docker variables in image building workflow
* Java: upgrade Java 11 to 11.0.15 and 17 to 17.0.3

2022-03-31
----------

* Ansible: switch from AWScli v1 to v2
* Ansible: dropping support for 4.x.x
* AWS: switch from AWScli v1 to v2
* Dind: switch from AWScli v1 to v2
* Node: dropping support for NodeJs 12
* Node: switch from AWScli v1 to v2
* Golang: switch from AWScli v1 to v2
* Golang: adding new 1.18 flavor
* Cloudsploit: switch from AWScli v1 to v2
* Python: dropping support for 3.6, adding support for 3.10
* Python: switch from AWScli v1 to v2
* Kubectl: Bumping kubectl to 1.23.x. Updating Helm & misc tools. Removing kubectx & kubens
* Kubectl: switch from AWScli v1 to v2
* PyNode: switching from node 12.x to 14.x
* PyNode: switch from AWScli v1 to v2
* Terraform: switch from AWScli v1 to v2
* Java: switch from AWScli v1 to v2

2022-02-28
----------

* PHP: installing xsl extension
* PHP: workaround for installing sockets and zip extensions
* Ansible: dropping support for 2.x & 3.x, adding a new 5.x.X image
* Terraform: updating TF to 1.1.x, along with associated tools
* PHP: bump to PHP 7.4.28, PHP 8.0.16 and PHP 8.1.3 (security update)
* Java: upgrade Java 11 to 11.0.14 and 17 to 17.0.2

2022-01-31
----------

* Golang: add gocover-cobertura

2021-12-31
----------

* React-native: dropping support
* PHP: remove support for PHP 7.3, update 7.4 and 8.0, create 8.1

2021-11-30
----------

* Percy: Switch to percy-cli instead of percy-agent
* Scoutsuite: removing this image, as we're now using cloudsploit instead.
* Kubectl: updating kubectl & associated tools. Removing eksctl & helmfile. Adding Kubent
* Platformsh: bumping client to 3.71.0
* Terraform: bumping to 1.0.11, along with associated tools
* Dind: updating docker-compose to 2.1.1, trivy to 0.21.0

2021-10-31
----------

* Java: remove Java 8 image
* Nodejs: add nodejs 16 image
* Nodejs: remove nodejs 10 image
* Nodejs: upgrade images to Debian 11
* AWS: updating base image to python 3.10.x
* Scoutsuite: updating base image to python 3.10.x
* Terraform: updating base image to python 3.10.x
* Terraform: updating to TF 1.0.x, terragrunt & infracost latest versions. Also dropping support for TF 0.13, 0.14, 0.15
* Nodejs: upgrade images to Debian 11.1
* PHP: remove support for PHP 7.2
* PHP: bump to 7.3.31, 7.4.24 and 8.0.11 and use Alpine 3.13 as base image
* PHP: update tools
* Ansible: adding new ansible 2.10.x, 3.x.x & 4.x.x flavors

2021-09-30
----------

* Kubectl : bumping client to 1.22.x, along with associated tools updates
* azure : bumping azure-cli version to 2.28.1
* nodejs: update version to use the latest from 10, 12, and 14 series.
* Removing jinja from build dependencies
* Removing Dockerfile templating to enforce single version Dockerfile for dependabot
* Pynode: adding python 3.9 image, dropping version 3.7
* Java: remove Modd, Maven and http call to mime types
* Java: add new Java 17 image
* Java: migrate to temurin images

2021-08-31
----------

* Adding a new container flavour for Aquasecurity's Cloudsploit
* Dind : removing libc6-compat to avoid name clashing, updating glibc version.
* Golang : adding a 1.17.x image version
* Golang : switching from python-pip to python3-pip

2021-07-31
----------

* bumping image version for bitcoind to 0.21.1
* adding postgresql-client to PHP images
* platformSh : bumping client to 3.67.x
* ansible : bumping to latest 2.9.x release
* azure : bumping azure-cli version
* kubectl : bumping kubectl, kuztomize & other tools' versions
* python : bumping base images minor versions
* terraform : bumping terraform minor versions, along with terragrunt & associated tools
* bumping base images for php, platformsh, ruby, azure, awslnx-systemd, scoutsuite, terraform, ansible, aws, golang

2021-06-30
----------

* bumping base image versions for Ruby, Ansible, AWS, Scoutsuite, Awslnx-systemd, Azure, Golang, Terraform, dind, sonar, kubectl, node
* Dropping terraform 12 support
* Python : misc dependencies updates
* Upgrade PHP musl-dev version to 1.2.2-r1 (not for PHP 7.2)
* Creating terraform 1.0.1 image

2021-05-31
----------

* Updating azure-cli to 2.24.0
* Bumping sonar to 4.6.2
* Bumping python base images to their latest versions
* Updating kubectl to 1.21, along with all associated tools
* Adding terraform 15.x image. Bumping other minor versions to the latest tag
* Adding infracost CI script

2021-04-30
----------

* Upgrade Composer version to 2.0.12 (not for PHP 7.2)
* Upgrade php-cs-fixer version to 2.18.5 (not for PHP 7.2)
* Added a new Percy image

2021-03-31
----------

* add pcov in PHP images
* add helmfile and helm diff plugin to kubectl images
* Upgrade Golang version: 1.16.1
* Upgrade Golang gitleaks version: 7.3.0
* Upgrade Golang go-mod-upgrade version: 0.4.0
* Upgrade Golang goswagger version: 0.26.1
* Upgrade Golang ci-lint version: 1.38.0
* Upgrade Golang migrate version: 4.14.1
* Upgrade Golang testfixtures version: 3.5.0
* Removing terraform from the azure image. Adding azure cli to the terraform image
* Bumping Scoutsuite to 5.10.2
* Bumping trivy to 0.16.0
* Upgrade Infracost to 0.8.2
* Add jq and bc to terraform image
* Bumping kubectl to 1.20.5 along with misc kubernetes tools
* Updating terraform 0.14.x image to 0.14.9

2021-02-28
----------

* Upgrade PHP versions to 7.3.27, 7.4.15 and 8.0.2
* Upgrade Composer version to 2.0.10 (not for PHP 7.2)
* Upgrade Iconv version to 1.15-r3 (not for PHP 7.2)
* Upgrade musl-dev version to 1.2.2-r0 (not for PHP 7.2)
* Upgrade php-cs-fixer version to 2.18.2 (not for PHP 7.2)
* Upgrade Xdebug version to version 3.0.3 (not for PHP 7.2)

2021-01-29
----------

* Update node base image to debian:10.7-slim
* Update kubectl base image to alpine:3.13
* Update dind base image to docker:20.10.2-dind
* Adding trivy to the dind image
* Upgrade Java 8 to 8u282 and 11 to 11.0.10
* Update platformsh base image to php:7.4-cli-alpine3.13
* Update platformsh client to 3.64.x
* Python : update base image versions
* Chrome : update puppeteer to 1.13 to fix CVE
* React-native : update base image to openjdk:8u282-jdk-slim (CVE fix)
* BREAKING CHANGE: Upgrade Taskfile to v3.2.2 (drop compatibility with v1.x.x definition files)

2021-01-25
----------

* Add PHP image version 8.0.0 and bump composer, php_cs_fixer, xdebug & redis versions
* Switch from [sensiolabs/security-checker](https://github.com/sensiolabs/security-checker) to [Local PHP Security Checker](https://github.com/fabpot/local-php-security-checker) (keep compatibility with existing binary name)
* Removed IBM image & associated tools
* Remove python 2.7 image (now EOL)
* Add a terraform 0.14.x image, remove multiple 13.x versions, updated associated tools
* Upgrade Kubectl to 1.20, along with associated k8s tools
* Update Sonar client to 4.6.x

2020-12-31
----------

* Add a python 3.9 image
* Add Infracost to the Terraform images

2020-11-30
----------

* Upgrade PHP versions to 7.2.34, 7.3.24 and 7.4.12
* Upgrade Composer version to 2.0.4
* Upgrade APCU version to 5.1.19
* Upgrade php-cs-fixer version to 2.16.7
* Upgrade Xdebug version to version 2.9.8
* Upgrade musl-dev version to 1.1.24-r10 to fix php image build
* Delete Composer plugin hirak/prestissimo
* Fix missing awscli missing from Node and React Native
* Upgrade Java 8 to 8u272 and 11 to 11.0.9
* Update SmartPy version in tezosqa image

2020-10-31
----------

* Upgrade terraform to 0.13.4 and terragrunt to 0.25.3 and add jq to image
* fix aws image dependencies with new pip resolver feature `--use-feature=2020-resolver`
* fix smartpy version in tezosqa image
* Upgrade Kubectl to 1.18.10
* Upgrade Eksctl to 0.30.0
* Upgrade Kubescore to 1.9.0
* Upgrade Kustomize to 3.8.5
* Upgrade Helm to 3.3.4
* Upgrading Scoutsuite to 5.10.1

2020-09-30
----------

* Upgrade Golang version: 1.15.2
* Upgrade Golang gitleaks version: 6.1.2
* Upgrade Golang ci-lint version: 1.31.0
* Upgrade Golang go-mod-upgrade version: 0.2.1
* Upgrade Golang migrate version: 4.12.2
* Upgrade Golang testfixtures version: 3.4.0
* Add rsync to Golang image

2020-08-31
----------

* Add terraform version 0.13.1
* Add rsync to aws image
* Upgrade PHP composer version to 1.10.10
* Upgrade PHP versions to 7.2.32, 7.3.20 and 7.4.8
* Add musl-dev==1.1.24-r9 to fix php image build
* Add jq in PHP image
* Add terraform-compliance v1.2.11 to terraform image
* Upgrade terraform to 0.12.29 in terraform and ibm images
* Change terraform versionning to add patch version value
* Upgrade IBM Cloud terraform provider to 1.10.0
* Upgrade Golang version: 1.14.7
* Update Kubectl to 1.18.6 + associated tools
* Update Scoutsuite to 5.9.1
* Add a new Terraform 0.13 image
- Update Ansible to 2.9.10
- Update Azure CLI to 2.10.1
- Update Terraform complaince CLI to 1.3.2
- Install awscli in kubectl image

2020-07-31
----------

* Add terragrunt v0.23.31 and git to terraform image
* Add zip and make to the AWS image
* Upgrade IBM Terraform provider to v1.8.1
* Upgrade Golang version: 1.14.6
* Upgrade Golang ci-lint version: 1.28.3
* Upgrade Golang goswagger version: 0.25.0
* Upgrade Golang go-mod-upgrade version: 0.2.0
* Upgrade Golang testfixtures version: 3.3.0
* Add go-bindata to golang image
* Upgrade Java 8 to 8u262 and 11 to 11.0.8
* Add [Taskfile](https://taskfile.dev) to the Node.js, Chrome, AWS and DinD images

2020-06-30
----------

* Upgrade bitcoind image to 0.20.0
* Add PHP COMPOSER_MEMORY_LIMIT env var
* Upgrade Java 8 to 8u252 and 11 to 11.0.7
* Install IBM CLI plugin for IBM Functions
* Upgrade Node 10 to 10.21.0 and 12 to 12.18.1
* Add Node 14 image
* Upgrade npm to 6.14.5 and nvm to 0.35.3 in Node images
* Upgrade Golang version: 1.14.4
* Upgrade Golang gitleaks version: 4.3.1
* Upgrade Golang goswagger version: 0.24.0
* Upgrade PHP composer version: 1.10.7
* Upgrade PHP xdebug version: 2.9.6
* Add tezosqa image with ligo, SmartPy and Pytezos

2020-05-28
----------

* Install helm on IBM image
* Upgrade PHP version: 7.2.31, 7.3.18 and 7.4.6
* Upgrade PHP composer version: 1.10.6
* Upgrade PHP memcached extension version: 3.1.5
* Upgrade PHP php-cs-fixer version: 2.16.3
* Upgrade PHP redis extension version: 5.2.2
* Upgrade PHP xdebug extension version: 2.9.5
* Restore ssh2 extension in PHP images
* Upgrade Golang version: 1.14.3
* Add Gitleaks, GolangCI-Lint, go-mod-upgrade, go-swagger, go-mock, goimports, migrate, modd and testfixtures to Golang image
* Add bitcoind image, version: 0.19.1
* Add the following libraries into the php image: libcrypto1.1, libssl1.1
* Add kubeval and kustomize to IBM image
* Add AWS Terraform provider in IBM image
* Add ibmcloud CLI cloud-databases plugin in IBM image
* Upgrade IBM Terraform Provider to 1.5.3
* Upgrade terraform to 0.12.26 in IBM Image

2020-04-30
----------

* Removing ansible 2.8 image
* Upgrade Node images to debian 10.3
* Move ibm image to Golang base image and build Null provider
* Upgrade ibm provider to 1.2.4
* Upgrade eksctl to 0.14.0
* Migrate the CI to GitHub Actions
* Increase DockerClient's timeout to 10 minutes
* Rename dind-aws to dind and add all provider cli (aws, ibm, azure)
* Add Helm cli to kubectl image
* Add a workflow dedicated to checking PR mergeability
* Install kubectl and kubernetes provider in IBM image
* Upgrade IBM cli to 1.0.0
* Upgrade IBM provider to 1.4.0
* Upgrade scoutsuite to 5.8.1
* Upgrade Azure cli to 2.4.0
* Removing Arachni image
* Upgrade misc Kubectl image components
* Upgrade Terraform to 0.12.24

2020-02-28
----------

* Add mysql-client in PHP images
* Add postgresql-client in java image
* Upgrade Golang version: 1.14
* Remove Glide, Gin and Modd from the golang image
* Upgrade Java 8 to 8u242 and 11 to 11.0.6
* Remove support for Node 8
* Switch every python related images to debian buster slim base
* Rename variable use for base image version in templated Dockerfile to `BASE_IMAGE_VERSION`
* Upgrade Node 10 to 10.19.0, Node 12 to 12.16.1 and NPM to 6.13.7
* Update Kubectl version (and associated tools) : 1.17
* Upgrade ScoutSuite: 5.7
* Adding Ansible to 2.9 in addition to 2.8
* Upgrade Azure CLI to 2.1.0 and Terraform to 0.12.21
* Create IBM image with terraform, ibm provider and ibmcloud cli
* Rename serverless image into pynode to manage serverless and cdk use cases

2019-12-26
----------

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
----------

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
