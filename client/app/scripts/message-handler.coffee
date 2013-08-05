gameEvents = require('./game-events')
io = require('socket.io-client')

Bacon = require('baconjs')
_ = require('underscore')

class MessageHandler
  constructor: (@game) ->

  connect: ->
    @gameSocket = @connectToServer()
    @bindEvents()

  connectToServer: ->
    io.connect('http://localhost:5000')

  bindEvents: ->
    gameEvents.socketMessage(@gameSocket, 'game-state').onValue @gotGameState
    gameEvents.socketMessage(@gameSocket, 'map').onValue @updateMap
    gameEvents.socketMessage(@gameSocket, 'info').onValue @gotServerInfo
    gameEvents.socketMessage(@gameSocket, 'new-player').onValue @addNewPlayer
    gameEvents.socketMessage(@gameSocket, 'player-leaving').onValue @playerLeaving
    gameEvents.socketMessage(@gameSocket, 'player-state-changed').onValue @playerStateChanged
    gameEvents.socketMessage(@gameSocket, 'rocket-moved').onValue @rocketMoved
    gameEvents.socketMessage(@gameSocket, 'rocket-destroyed').onValue @rocketDestroyed

    gameEvents.globalBus.filter((ev) -> ev.target == 'server').onValue @sendToServer
  gotGameState: (event) =>
    state = event.data
    for part in state
      switch part.type
        when 'map' then @updateMap { data: part.state }
        when 'player' then @addNewPlayer { data: part.state }

  updateMap: (event) =>
    @game.setNewMap(event.data)

  gotServerInfo: (event) =>
    console.log event.data

  addNewPlayer: (ev) =>
    playerData = ev.data
    @game.addNewPlayer(playerData)

  playerLeaving: (ev) =>
    console.log "Removing player"
    playerId = ev.data
    @game.removePlayer(playerId)

  playerStateChanged: (ev) =>
    newData = ev.data
    @game.playerStateChanged(newData)

  rocketMoved: (ev) =>
    @game.moveRocket(ev.data)

  rocketDestroyed: (ev) =>
    @game.removeRocket(ev.data.id)

  sendToServer: (event) =>
    serverData = event.data
    @gameSocket.emit(serverData.key, serverData.data)

  ourId: ->
    @gameSocket.socket.sessionid

module.exports = MessageHandler
