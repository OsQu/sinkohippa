COFFEE=./node_modules/.bin/coffee
BROWSERIFY=./node_modules/.bin/browserify
BUNDLE_FILE_NAME=bundle.js

SOURCES=$(shell find app/scripts -type f -name '*.coffee')
JS_SOURCES=$(patsubst app/scripts/%, compiled/%, $(SOURCES:.coffee=.js))
STATIC_FILES=404.html,env.json,favicon.ico,index.html,robots.txt

all: build-dist

# === Application ===

paskaa:
	# $(SOURCES)
	# JS_SOURCES
	# $(JS_SOURCES)

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


clean:
	rm -rf compiled dist
