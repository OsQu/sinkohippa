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
    gameEvents.socketMessage(@gameSocket, 'game-state').onValue @, 'gotGameState'
    gameEvents.socketMessage(@gameSocket, 'map').onValue @, 'updateMap'
    gameEvents.socketMessage(@gameSocket, 'info').onValue @, 'gotServerInfo'
    gameEvents.socketMessage(@gameSocket, 'new-player').onValue @, 'addNewPlayer'
    gameEvents.socketMessage(@gameSocket, 'player-leaving').onValue @, 'playerLeaving'
    gameEvents.socketMessage(@gameSocket, 'player-state-changed').onValue @, 'playerStateChanged'
    gameEvents.socketMessage(@gameSocket, 'rocket-moved').onValue @, 'rocketMoved'
    gameEvents.socketMessage(@gameSocket, 'rocket-destroyed').onValue @, 'rocketDestroyed'
    gameEvents.socketMessage(@gameSocket, 'new-corpse').onValue @, 'newCorpse'
    gameEvents.socketMessage(@gameSocket, 'add-explosion').onValue @, 'addExplosion'
    gameEvents.socketMessage(@gameSocket, 'remove-explosion').onValue @, 'removeExplosion'

    gameEvents.globalBus.filter((ev) -> ev.target == 'server').onValue @, 'sendToServer'
    gameEvents.globalBus.filter((ev) -> ev.target == 'join-game').onValue @, 'joinGame'

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

  newCorpse: (ev) ->
    @game.addCorpse(ev.data)

  addExplosion: (ev) ->
    @game.addExplosion(ev.data)

  removeExplosion: (ev) ->
    @game.removeExplosion(ev.data.id)

  ourId: ->
    @gameSocket.socket.sessionid

module.exports = MessageHandler
