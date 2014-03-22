Sinkohippa client
================

Dependencies
------------
Following packages are needed to run the frontend
* [grunt](http://gruntjs.com/)
* [node](http://nodejs.org/)

Installation
------------

```
npm install -g grunt-cli
git submodule update --init
npm install
cp app/env.json.sample app/env.json
```

Developing
-------
To start developing new cool features to Sinkohippa, simply type:

```
grunt server
```

To run tests, type

```
grunt server:test
```
