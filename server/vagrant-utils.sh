#/bin/bash

#
# Utils
#

if [ ! -f /root/setup-utils ]
then
  aptitude install -y ruby
  aptitude install -y rubygems1.8
  gem install foreman
  touch /root/setup-utils
else
  echo "All utils already installed"
fi

