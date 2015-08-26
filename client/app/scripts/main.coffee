'use strict'

console.log "Real mainjs"
Lobby = require('./lobby')
Bacon = require('baconjs')

environment = Bacon.fromPromise($.getJSON("env.json"))

environment.onValue (env) ->
  lobby = new Lobby(serverUrl: env["server_url"])
  lobby.openLobby()
