BuildBox
========

The repository provides a complete set of build tools for web developpers. **These
images MUST NOT be used in production**. The targeted usage of those images is GitlabCI.

Versions
--------

Please review the [CHANGELOG.md](CHANGELOG.md) file for versions per tag.

Testing
-------

Each box is tested and built using TravisCI. 

The ``travis.py`` script try to be clever:
 - PR: only images with modified files are built.
 - Merge to master: only images with modified files are built and pushed to the docker registry with the tag ``latest-IMAGE``
 - TAG: all images are built and pushed to the docker registry
