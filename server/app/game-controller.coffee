debug = require('debug')('sh:game-controller')
ROT = require('./vendor/rot.js/rot')

class GameController
  constructor: ->
    @map = []
    @generateMap(@map)
    debug('Map ready')

  generateMap: (map) ->
    debug('Generationg map')
    generator = new ROT.Map.Arena(80.25)
    generator.create (x, y, wall) ->
      map.push {x, y, wall}

  getMap: -> @map
instance = new GameController()
module.exports = instance

