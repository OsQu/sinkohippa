Sinkohippa client
================

Dependencies
------------
Following packages are needed to run the frontend
* [node](http://nodejs.org/)
* [bundler](http://bundler.io/) (and ruby 2.1.0)

Installation
------------

```
git submodule update --init
npm install
bundle install
cp app/env.json.sample app/env.json
```

Developing
-------
To start developing new cool features to Sinkohippa, build the project to `dist/` folder with make(1)

```
make app
```

And then run the server with npm script:

```
npm run server
```

And point your browser to `http://localhost:8080`

To run tests, type

```
make test
```

And then run the test server with npm script:

```
npm run test
```

And point your browser to `http://localhost:8081`
