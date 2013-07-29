ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')
_ = require('underscore')
io = require('socket.io-client')

Map = require('./map')
KeyboardController = require('./keyboard-controller')
gameEventsHandler = require('./events')

class Game
  init: ->
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
    @map.render(@display)
    _.forEach @players, (p) => p.render(@display)

  gameLoop: ->
    console.log("render")
    @render()
    @requestAnimationFrame(_.bind(@gameLoop, @))

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
