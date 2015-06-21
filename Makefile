SHELL     := /bin/bash
COFFEE     = node_modules/.bin/coffee
COFFEELINT = node_modules/.bin/coffeelint
MOCHA      = node_modules/.bin/mocha --compilers coffee:coffee-script --require "coffee-script/register"
REPORTER   = spec

.PHONY: lint
lint:
	@[ ! -f coffeelint.json ] && $(COFFEELINT) --makeconfig > coffeelint.json || true
	@$(COFFEELINT) --file ./coffeelint.json src
ISTANBUL   = node_modules/.bin/istanbul
COVERALLS  = node_modules/coveralls/bin/coveralls.js

test-coverage:
	# npm install --save-dev coffee-coverage istanbul coveralls
	export DEBUG=*:*,-mocha:* && mocha --recursive \
	      --compilers coffee:coffee-script/register \
	      --require coffee-coverage/register-istanbul \
	      test
	./node_modules/.bin/istanbul report text-summary lcov
	cat coverage/lcov.info | node_modules/coveralls/bin/coveralls.js

.PHONY: build
build:
	@make lint || true
	@$(COFFEE) $(CSOPTS) --map --compile --output lib src

.PHONY: test
test: build
	@DEBUG=*:*,-mocha:* $(MOCHA) --reporter $(REPORTER) test/ --grep "$(GREP)"

.PHONY: release-major
release-major: build test
	@npm version major -m "Release %s"
	@git push
	@npm publish

.PHONY: release-minor
release-minor: build test
	@npm version minor -m "Release %s"
	@git push
	@npm publish

.PHONY: release-patch
release-patch: build test
	@npm version patch -m "Release %s"
	@git push
	@npm publish

.PHONY: upgrade-npm-dependencies
upgrade-npm-dependencies:
	coffee scripts/upgrade-modules.coffee

	@cd api2 && \
	  npm install && \
	  ./node_modules/.bin/npm-check-updates --upgrade && \
	  npm install
	#$(MAKE) test
	#git add ./package.json
	#git commit -m'Upgrade NPM dependencies'
