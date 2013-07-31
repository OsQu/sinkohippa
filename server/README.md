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

Vagrant
-------

There is also Vagrantfile so setupping the backend couldn't be easier: Install Vagrant from [http://www.vagrantup.com/](http://www.vagrantup.com/) and after that type:

```
vagrant up
```

Installation script also introduces ```debug``` alias which can be used to run the node in debug-mode. see ```~/.bash_aliases``` for more details
