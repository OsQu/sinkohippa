'use strict'

console.log "Real mainjs"
Game = require('./game')
Hud = require('./hud')
Bacon = require('baconjs')

environment = Bacon.fromPromise($.getJSON("env.json"))

hud = new Hud() # TODO: Some nice loading indicator

environment.onValue (env) ->
  sinkohippa = new Game(serverUrl: env["server_url"])
  sinkohippa.start()

