COFFEE=./node_modules/.bin/coffee
BROWSERIFY=./node_modules/.bin/browserify
COMPASS=bundle exec compass compile
BUNDLE_FILE_NAME=bundle.js

SOURCES=$(shell find app/scripts -type f -name '*.coffee')
JS_SOURCES=$(patsubst app/scripts/%, compiled/%, $(SOURCES:.coffee=.js))
STATIC_FILES=dist/404.html dist/env.json dist/favicon.ico dist/index.html dist/robots.txt

all: app test

# === Application ===

# Compile any .coffee file to .js file
compiled/%.js: app/scripts/%.coffee
	$(COFFEE) -b -o $(@D) $<

compiled/vendor:
	cp -R app/scripts/vendor compiled/

compiled/$(BUNDLE_FILE_NAME): $(JS_SOURCES) compiled/vendor
	$(BROWSERIFY) compiled/main.js -o $@

compiled/main.css:
	$(COMPASS)

dist/scripts/vendor:
	mkdir -p dist/scripts
	cp -R app/scripts/vendor dist/scripts/vendor

dist/scripts/$(BUNDLE_FILE_NAME): compiled/$(BUNDLE_FILE_NAME)
	mkdir -p dist/scripts
	cp compiled/$(BUNDLE_FILE_NAME) dist/scripts/$(BUNDLE_FILE_NAME)

dist/styles: compiled/main.css
	mkdir -p dist/styles
	cp compiled/main.css dist/styles/main.css

$(STATIC_FILES):
	mkdir -p dist
	cp app/$(@F) $@

.PHONY: app
app: $(STATIC_FILES) dist/scripts/vendor dist/scripts/$(BUNDLE_FILE_NAME) dist/styles

# === Tests ===

TESTABLE_JS_SOURCES=$(filter-out compiled/main.js, $(JS_SOURCES))
SPECS=$(shell find test/spec -type f -name '*.coffee')
JS_SPECS=$(patsubst test/spec/%, test/compiled/spec/%, $(SPECS:.coffee=.js))
SPEC_MAIN_JS=test/compiled/scripts/main.js
SYM_LINKS=test/compiled/scripts/vendor test/compiled/client

test/compiled/%.js: test/%.coffee
	$(COFFEE) -b -o $(@D) $<

test/compiled/$(BUNDLE_FILE_NAME): $(TESTABLE_JS_SOURCES) $(JS_SPECS) $(SPEC_MAIN_JS) $(SYM_LINKS) compiled/vendor
	$(BROWSERIFY) test/compiled/scripts/main.js -o $@

test/compiled/scripts/vendor: $(SPEC_MAIN_JS)
	cp -R app/scripts/vendor test/compiled/scripts/

test/compiled/client: $(TESTABLE_JS_SOURCES)
	cp -R compiled test/compiled/client

.PHONY: test
test: test/compiled/$(BUNDLE_FILE_NAME)

clean:
	rm -rf compiled test/compiled dist
