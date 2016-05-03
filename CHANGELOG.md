Versions
========


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