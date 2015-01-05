COFFEE=./node_modules/.bin/coffee
BROWSERIFY=./node_modules/.bin/browserify
BUNDLE_FILE_NAME=bundle.js

STATIC_FILES=404.html,env.json,favicon.ico,index.html,robots.txt

all: build-dist

tmp/main.js:
	$(COFFEE) -b -o tmp app/scripts
	cp -R app/scripts/vendor tmp/

tmp/$(BUNDLE_FILE_NAME): tmp/main.js
	$(BROWSERIFY) tmp/main.js -o tmp/$(BUNDLE_FILE_NAME)

build-dist: tmp/$(BUNDLE_FILE_NAME)
	mkdir -p dist/scripts
	cp tmp/$(BUNDLE_FILE_NAME) dist/$(BUNDLE_FILE_NAME)
	cp -R app/scripts/vendor dist/scripts/vendor
	cp app/{$(STATIC_FILES)} dist/


clean:
	rm -rf tmp dist
