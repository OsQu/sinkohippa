ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')
_ = require('underscore')
io = require('socket.io-client')

Map = require('./map')
KeyboardController = require('./keyboard-controller')
gameEventsHandler = require('./events')

class Game
  init: ->
    @fps = 30

    @display = new ROT.Display()
    @map = new Map()
    @map.generate()

    @players = []

    @gameContainer = $('#game-container')

    @gameContainer.append @display.getContainer()

    @keyboardController = new KeyboardController()
    @gameSocket = @connectToServer()
    gameEventsHandler.handleEvents(@gameSocket)

  render: ->
    console.log("render")
    @map.render(@display)
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

module.exports = Game
