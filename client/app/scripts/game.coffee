ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')

Map = require('./map')

class Game
  init: ->
    @display = new ROT.Display()
    @map = new Map()
    @map.generate()
    @gameContainer = $('#game-container')

    @gameLoop = Bacon.fromPoll 100, @gameLoop
    @gameContainer.append @display.getContainer()

  render: ->
    @map.render(@display)

  gameLoop: =>
    console.log "rendering game"
    @render()

  start: ->
    console.log "Starting engine"
    @gameLoopStream = @gameLoop.onValue()

module.exports = Game
