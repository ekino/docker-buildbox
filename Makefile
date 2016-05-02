NODE_DIRS = $(shell ls -d node*)
PHP_DIRS = $(shell ls -d php*)
CURRENT_PATH = $(shell pwd)

help:     ## Display this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

test-node:  ## Format code to respect CS
	for DIR in $(NODE_DIRS) ; do \
		cd $(CURRENT_PATH); \
		echo "Testing : $${DIR}"; \
		cd $${DIR}; \
		echo " > Build image"; \
		docker build -t $${DIR} --no-cache . || exit 1; \
		echo " > Testing basic commands"; \
		docker run --rm $${DIR} node --version || exit 1; \
		docker run --rm $${DIR} npm --version  || exit 1; \
		docker run --rm $${DIR} sass --version || exit 1; \
	done
	echo "done!"

test-php:  ## Format code to respect CS
	for DIR in $(PHP_DIRS) ; do \
		cd $(CURRENT_PATH); \
		echo "Testing : $${DIR}"; \
		cd $${DIR}; \
		echo " > Build image"; \
		docker build -t $${DIR} --no-cache . || exit 1; \
		echo " > Testing basic commands"; \
		docker run --rm $${DIR} php --version || exit 1; \
		docker run --rm $${DIR} composer --version || exit 1; \
	done
	echo "done!"
