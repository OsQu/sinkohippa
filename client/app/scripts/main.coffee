'use strict'

console.log "Real mainjs"
Lobby = require('./lobby')
Bacon = require('baconjs')

environment = Bacon.fromPromise($.getJSON("env.json"))

environment.onValue (env) ->
  lobby = new Lobby(serverUrl: env["server_url"])
  # Just to get some nethack feeling, later use this as a nick
  lobby.askName().done (name) ->
    # TODO: Do something with name
    console.log "Guys name is #{name}"
    lobby.openLobby()
