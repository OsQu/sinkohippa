ROT = require('./vendor/rot.js/rot')
Tile = require('./tile')
mapDimensions = require('./constants')['mapDimensions']
_ = require('underscore')

class Map
  constructor: (mapData) ->
    @tiles = _.reduce mapData, (tiles, tileData) ->
      tiles.push new Tile tileData.x, tileData.y, tileData.wall
      tiles
    , []


  generate: () ->
    generator = new ROT.Map.Arena(mapDimensions.width, mapDimensions.height)
    generator.create (x,y, wall) =>
      @tiles.push new Tile x, y, wall

  getTiles: () -> # Terrible
    @tile

  render: (display) =>
    _.each @tiles, (tile) =>
      display.draw tile.x, tile.y, tile.getChar()

  renderTile: (display, x, y) ->
    tile = _.find @tiles, (t) -> t.x == x && t.y == y
    return unless tile?
    display.draw tile.x, tile.y, tile.getChar()

module.exports = Map
