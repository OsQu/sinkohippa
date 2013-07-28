ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')
_ = require('underscore')

Map = require('./map')

class Game
  init: ->
    @display = new ROT.Display()
    @map = new Map()
    @map.generate()

    @players = []

    @gameContainer = $('#game-container')

    @gameLoop = Bacon.fromPoll 100, @gameLoop
    @gameContainer.append @display.getContainer()

  render: ->
    @map.render(@display)
    _.forEach @players, (p) => p.render(@display)

  gameLoop: =>
    console.log "rendering game"
    @render()

  start: ->
    console.log "Starting engine"
    @gameLoopStream = @gameLoop.onValue()

  addPlayer: (player) ->
    @players.push(player)

module.exports = Game
