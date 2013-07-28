ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')
_ = require('underscore')

Map = require('./map')
KeyboardController = require('./keyboard-controller')

class Game
  init: ->
    @display = new ROT.Display()
    @map = new Map()
    @map.generate()

    @players = []

    @gameContainer = $('#game-container')

    @gameLoop = Bacon.fromPoll 100, @gameLoop
    @gameContainer.append @display.getContainer()

    @keyboardController = new KeyboardController()

  render: ->
    @map.render(@display)
    _.forEach @players, (p) => p.render(@display)

  gameLoop: =>
    @render()

  start: ->
    console.log "Starting engine"
    @gameLoopStream = @gameLoop.onValue()

  addPlayer: (player) ->
    @players.push(player)

module.exports = Game
