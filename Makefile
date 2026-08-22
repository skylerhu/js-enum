LIB_NAME := $(shell jq -r .name package.json)
LIB_VERSION := $(shell jq -r .version package.json)
VERSIONED_FILE := $(LIB_NAME)-$(LIB_VERSION).min.js
LATEST_LINK := $(LIB_NAME)-latest.min.js

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

.PHONY: help clean clean-build clean-install clean-test lint test build release

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean: clean-build clean-install clean-test ## remove all build, test, coverage

clean-build: ## remove build artifacts
	rm -fr dist/

clean-install: ## remove node_modules
	rm -rf node_modules/
	rm -f package-lock.json
	npm cache clean --force

clean-test: ## remove test and coverage artifacts
	rm -rf .coverage

lint: ## check style with eslint
	npm run lint

test: lint ## run tests with coverage
	npm run test

build: test clean-build ## build dist and update releases
	npm run build
	cp -n "dist/index.js" "releases/$(VERSIONED_FILE)" || true
	cd releases && ln -sf "$(VERSIONED_FILE)" "$(LATEST_LINK)"

release: build ## build and publish to npm
	npm publish
