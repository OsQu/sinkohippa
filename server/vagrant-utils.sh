#/bin/bash

#
# Utils
#

if [ ! -f /root/setup-utils ]
then
  # debug alias for running node in debug mode
  echo "alias debug='DEBUG=sh:* PORT=5000 ./node_modules/.bin/coffee --nodejs debug app/app.coffee'" >> /home/vagrant/.bash_aliases
  chown vagrant:vagrant /home/vagrant/.bash_aliases

  aptitude install -y git
  aptitude install -y ruby
  aptitude install -y rubygems1.8
  gem install foreman
  npm install -g grunt-cli

  touch /root/setup-utils
else
  echo "All utils already installed"
fi

