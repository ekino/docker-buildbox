Versions
========

2016.12-dev
-----------

* Slightly reduce the size of the Java image
* Add the AWS CLI to all images
* Add packages ocaml & libelf-dev for FlowType checking

2016.12.05
----------

* Fix maven install on Java
* Fix clean commands
* Update Yarn 0.18

2016.11.25
----------

* Use Debian 8.6 as base image
* Use only major version, php7.0 => php7, etc ...
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
