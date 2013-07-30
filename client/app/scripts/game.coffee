ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')
_ = require('underscore')
io = require('socket.io-client')

Map = require('./map')
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

    gameEvents.socketMessage(@gameSocket, 'info').onValue (event) -> console.log(event.data)
    gameEvents.socketMessage(@gameSocket, 'map').onValue (event) =>
      @map = new Map(event.data)
      console.log "Set new map"

    gameEvents.globalBus.onValue _.bind(@fromGlobalBus, @)
    gameEvents.globalBus.filter((ev) -> ev.key == 'server').onValue(_.bind(@sendToServer, @))

  render: ->
    @map?.render(@display)
    _.forEach @players, (p) => p.render(@display)

  gameLoop: ->
    setTimeout =>
      @requestAnimationFrame(_.bind(@gameLoop, @))
      @render()
    , 1000 / @fps

  start: ->
    console.log "Starting engine"
    @requestAnimationFrame(_.bind(@gameLoop, @))

  addPlayer: (player) ->
    @players.push(player)

  connectToServer: ->
    io.connect('http://localhost:5000')

  requestAnimationFrame: (cb) ->
    window.requestAnimationFrame(cb)

  fromGlobalBus: (event) ->

  sendToServer: (event) ->
    serverData = event.data
    @gameSocket.emit(serverData.key, serverData.data)


module.exports = Game
