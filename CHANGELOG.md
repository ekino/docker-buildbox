Versions
========

2017-11-24
----------

* Add rsync and tzdata into dind-aws image
* Add sensiolabs' security-checker to php images

2017-11-01
----------

* BC break: dind-aws image is now based on Alpine
* Upgrade Docker version to 17.09 and Docker Compose to 1.16.1 in dind-aws image
* Upgrade Java version: 8u151-1~webupd8~0
* Upgrade PHP version: 5.6.31, 7.1.9
* Upgrade PHP Redis: 3.1.4
* Add Node 8.6
* Upgrade node 6.11.3
* Remove Node 4.8
* Upgrade golang: 1.9
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
