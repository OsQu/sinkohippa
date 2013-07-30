ROT = require('./vendor/rot.js/rot')
Tile = require('./tile')
_ = require('underscore')

class Map
  constructor: (mapData) ->
    @tiles = _.reduce mapData, (tiles, tileData) ->
      tiles.push new Tile tileData.x, tileData.y, tileData.wall
      tiles
    , []


  generate: () ->
    generator = new ROT.Map.Arena(80, 25)
    generator.create (x,y, wall) =>
      @tiles.push new Tile x, y, wall

  getTiles: () -> # Terrible
    @tile

  render: (display) =>
    _.each @tiles, (tile) =>
      display.draw tile.x, tile.y, tile.getChar()

module.exports = Map
