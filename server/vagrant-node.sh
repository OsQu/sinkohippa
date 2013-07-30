#!/usr/bin/env bash

#
# node
#
if [ ! -f /root/setup-node ]
then
  aptitude update
  aptitude install -y python-software-properties python g++ make
  apt-add-repository ppa:chris-lea/node.js
  aptitude update
  aptitude install -y nodejs
  touch /root/setup-node
else
    echo "Node.js already installed"
fi
