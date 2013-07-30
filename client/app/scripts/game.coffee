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
    @playersForRendering = []

    # Ugly and temporary
    # I want to separate render logic from controlling the player.
    # Maybe separate player-controller-class which will init the buttons
    @ownPlayer = new Player()
    @ownPlayer.initButtons()

    @display = new ROT.Display()
    @gameContainer = $('#game-container')
    @gameContainer.append @display.getContainer()

    @keyboardController = new KeyboardController()

    @gameSocket = @connectToServer()

    gameEvents.socketMessage(@gameSocket, 'info').onValue (event) -> console.log(event.data)
    gameEvents.socketMessage(@gameSocket, 'map').onValue (event) =>
      @map = new Map(event.data)
      console.log "Set new map"
    gameEvents.socketMessage(@gameSocket, 'state').onValue _.bind(@stateUpdated, @)

    gameEvents.globalBus.filter((ev) -> ev.target == 'server').onValue(_.bind(@sendToServer, @))

  render: ->
    @map?.render(@display)
    _.forEach @playersForRendering, (p) => p.render(@display)

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

  sendToServer: (event) ->
    serverData = event.data
    @gameSocket.emit(serverData.key, serverData.data)

  stateUpdated: (ev) ->
    @playersForRendering = _.map ev.data.players, (p) -> new Player('', p.x, p.y)
    console.log("state updated")

module.exports = Game
