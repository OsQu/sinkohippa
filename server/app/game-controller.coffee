debug = require('debug')('sh:game-controller')
ROT = require('./vendor/rot.js/rot')

class GameController
  constructor: ->
    @map = []
    @generateMap(@map)
    @players = []
    debug('Map ready')

  generateMap: (map) ->
    debug('Generationg map')
    generator = new ROT.Map.Arena(80.25)
    generator.create (x, y, wall) ->
      map.push {x, y, wall}

  getMap: -> @map

  addPlayer: (id) ->
    player =
      id: id
      x: 0
      y: 0
    @players.push(player)

instance = new GameController()
module.exports = instance

