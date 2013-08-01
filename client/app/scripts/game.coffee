ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')
_ = require('underscore')
io = require('socket.io-client')

Map = require('./map')
Player = require('./player')
KeyboardController = require('./keyboard-controller')

gameEvents = require('./game-events')

class Game
  init: ->
    @fps = 30
    @players = []

    @display = new ROT.Display()
    @gameContainer = $('#game-container')
    @gameContainer.append @display.getContainer()

    @keyboardController = new KeyboardController()

    @gameSocket = @connectToServer()
    @bindEvents()

  bindEvents: ->
    gameEvents.socketMessage(@gameSocket, 'map').onValue @updateMap
    gameEvents.socketMessage(@gameSocket, 'info').onValue @gotServerInfo
    gameEvents.socketMessage(@gameSocket, 'new-player').onValue @addNewPlayer
    gameEvents.socketMessage(@gameSocket, 'player-state-changed').onValue @playerStateChanged

    gameEvents.globalBus.filter((ev) -> ev.target == 'server').onValue @sendToServer

  updateMap: (event) =>
    @map = new Map(event.data)
    @renderMap()
    console.log "New map set and rendered"

  gotServerInfo: (event) =>
    console.log event.data

  addNewPlayer: (ev) =>
    playerData = ev.data
    console.log "Adding new player"
    player = new Player(playerData.id, playerData.x, playerData.y)
    if player.id == @gameSocket.socket.sessionid
      console.log "Found our player!"
      player.initButtons()

    @players.push(player)

  playerStateChanged: (ev) =>
    newData = ev.data
    player = _.find(@players, (p) -> p.id == newData.id)
    player.newX = newData.x
    player.newY = newData.y

  sendToServer: (event) =>
    serverData = event.data
    @gameSocket.emit(serverData.key, serverData.data)

  render: ->
    _.forEach @players, (p) => p.render(@display)

  renderMap: ->
    @map?.render(@display)

  gameLoop: ->
    setTimeout =>
      @requestAnimationFrame(_.bind(@gameLoop, @))
      @render()
    , 1000 / @fps

  start: ->
    console.log "Starting engine"
    @requestAnimationFrame(_.bind(@gameLoop, @))

  connectToServer: ->
    io.connect('http://localhost:5000')

  requestAnimationFrame: (cb) ->
    window.requestAnimationFrame(cb)

module.exports = Game
