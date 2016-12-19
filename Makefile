NODE_DIRS = $(shell ls -d node*)
PHP_DIRS = $(shell ls -d php*)
JAVA_DIRS = $(shell ls -d java*)
CURRENT_PATH = $(shell pwd)

help:     ## Display this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
