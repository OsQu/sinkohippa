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
    io.connect(@game.serverUrl)

  bindEvents: ->
    gameEvents.socketMessage(@gameSocket, 'game-state').onValue (data) => @gotGameState(data)
    gameEvents.socketMessage(@gameSocket, 'map').onValue (data) => @updateMap(data)
    gameEvents.socketMessage(@gameSocket, 'info').onValue (data) => @gotServerInfo(data)
    gameEvents.socketMessage(@gameSocket, 'new-player').onValue (data) => @addNewPlayer(data)
    gameEvents.socketMessage(@gameSocket, 'player-leaving').onValue (data) => @playerLeaving(data)
    gameEvents.socketMessage(@gameSocket, 'player-state-changed').onValue (data) => @playerStateChanged(data)
    gameEvents.socketMessage(@gameSocket, 'rocket-moved').onValue (data) => @rocketMoved(data)
    gameEvents.socketMessage(@gameSocket, 'rocket-destroyed').onValue (data) => @rocketDestroyed(data)

    gameEvents.globalBus.filter((ev) -> ev.target == 'server').onValue (data) => @sendToServer(data)
    gameEvents.globalBus.filter((ev) -> ev.target == 'join-game').onValue (data) => @joinGame(data)

  listenMessages: (key) ->
    gameEvents.socketMessage(@gameSocket, key)

  gotGameState: (event) ->
    state = event.data
    for part in state
      switch part.type
        when 'map' then @updateMap { data: part.state }
        when 'player' then @addNewPlayer { data: part.state }
        when 'score' then @setScores { data: part.state }

  updateMap: (event) ->
    @game.setNewMap(event.data)

  gotServerInfo: (event) ->
    console.log event.data

  addNewPlayer: (ev) ->
    playerData = ev.data
    @game.addNewPlayer(playerData)

  setScores: (ev) ->
    scores = ev.data
    @game.setScores(scores)

  playerLeaving: (ev) ->
    console.log "Removing player"
    playerId = ev.data
    @game.removePlayer(playerId)

  playerStateChanged: (ev) ->
    newData = ev.data
    @game.playerStateChanged(newData)

  rocketMoved: (ev) ->
    @game.moveRocket(ev.data)

  rocketDestroyed: (ev) ->
    @game.removeRocket(ev.data.id)

  sendToServer: (event) ->
    serverData = event.data
    @gameSocket.emit(serverData.key, serverData.data)

  joinGame: (ev) ->
    gameId = ev.data.gameId
    url = ev.data.url
    playerName = ev.data.playerName
    $.ajax
      url: url
      type: 'PUT'
      data:
        game_id: gameId
        player_id: @ourId()
        player_name: playerName


  ourId: ->
    @gameSocket.socket.sessionid

module.exports = MessageHandler
