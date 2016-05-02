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
		docker build -t test-$${DIR} . > build.log ; \
		echo " > Testing basic commands"; \
		docker run --rm test-$${DIR} node --version ; \
		docker run --rm test-$${DIR} npm --version ; \
		docker run --rm test-$${DIR} sass --version ; \
		(docker rmi -f $${DIR} || exit 0); \
		echo " > Rename image test-$${DIR} => $${DIR}"; \
		docker rename test-$${DIR} $${DIR}; \
	done
