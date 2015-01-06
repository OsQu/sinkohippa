COFFEE=./node_modules/.bin/coffee
BROWSERIFY=./node_modules/.bin/browserify
BUNDLE_FILE_NAME=bundle.js

SOURCES=$(shell find app/scripts -type f -name '*.coffee')
JS_SOURCES=$(patsubst app/scripts/%, compiled/%, $(SOURCES:.coffee=.js))
STATIC_FILES=404.html,env.json,favicon.ico,index.html,robots.txt

all: build-dist

# === Application ===

# Compile any .coffee file to .js file
compiled/%.js: app/scripts/%.coffee
	$(COFFEE) -b -o $(@D) $<

compiled/vendor:
	cp -R app/scripts/vendor compiled/

compiled/$(BUNDLE_FILE_NAME): $(JS_SOURCES) compiled/vendor
	$(BROWSERIFY) compiled/main.js -o $@

.PHONY: build-dist
build-dist: compiled/$(BUNDLE_FILE_NAME)
	mkdir -p dist/scripts
	cp compiled/$(BUNDLE_FILE_NAME) dist/scripts/$(BUNDLE_FILE_NAME)
	cp -R app/scripts/vendor dist/scripts/vendor
	cp app/{$(STATIC_FILES)} dist/

# === Tests ===

TESTABLE_JS_SOURCES=$(filter-out compiled/main.js, $(JS_SOURCES))
SPECS=$(shell find test/spec -type f -name '*.coffee')
JS_SPECS=$(patsubst test/spec/%, test/compiled/spec/%, $(SPECS:.coffee=.js))
SPEC_MAIN_JS=test/compiled/scripts/main.js
SYM_LINKS=test/compiled/scripts/vendor test/compiled/client

paskaa:
	# $(TESTABLE_JS_SOURCES)
	# $(JS_SPECS)

test/compiled/%.js: test/%.coffee
	$(COFFEE) -b -o $(@D) $<

test/compiled/$(BUNDLE_FILE_NAME): $(TESTABLE_JS_SOURCES) $(JS_SPECS) $(SPEC_MAIN_JS) $(SYM_LINKS) compiled/vendor
	$(BROWSERIFY) test/compiled/scripts/main.js -o $@

test/compiled/scripts/vendor:
	ln -s ../../../app/scripts/vendor test/compiled/scripts/vendor

test/compiled/client: $(TESTABLE_JS_SOURCES)
	ln -s ../../compiled test/compiled/client

.PHONY: test
test: test/compiled/$(BUNDLE_FILE_NAME)
	# DO NOTHING

clean:
	rm -rf compiled test/compiled dist
