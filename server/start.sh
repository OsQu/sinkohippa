PORT=5000 DEBUG=sh:main forever start -p production/ -l production.log -a -c ./node_modules/.bin/coffee app/app.coffee
