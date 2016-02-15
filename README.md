BuildBox
========

The idea behing this Dockerfile is to provide a complete set of build tools for web developpers. This
image MUST NOT be used in production.

Usage
-----

      $ source /root/.bashrc         # make sure the .bashrc is sourced to (phpenv and nvm are available)
      $ phpenv local 5.6.18          # use php 5.6.18
      $ nvm use 4.3.0                # use node 4.3.0


Versions
--------

Please review the [CHANGELOG.md](CHANGELOG.md) file for versions per tag.