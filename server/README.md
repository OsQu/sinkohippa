Sinkohippa backend
=================

Dependencies
------------

Following packages are needed to run the backend:

* [node](http://nodejs.org/)
* [foreman](https://github.com/ddollar/foreman)

Installation
------------

Install node from [http://nodejs.org/download/](http://nodejs.org/download/)

Install foreman with gem:

```
gem install foreman
```

After that install project dependencies with `npm install`

Running
-------

```
foreman start backend
```

To test that backend server is running correctly, go to `http://localhost:5000`
with your browser

Running tests
------------

```
foreman start test
```
