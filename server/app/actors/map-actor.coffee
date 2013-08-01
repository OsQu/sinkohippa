ROT = require('../vendor/rot.js/rot')
debug = require('debug')('sh:map-actor')
_ = require('underscore')

class MapActor
  constructor: (@manager) ->
    @type = 'map'
    @map = []
    @mapWidth = 80
    @mapHeight = 25
    @generateMap(@map, @mapWidth, @mapHeight)
    @arrayedMap = @makeTwoDimensionArrayFromMap(@map)

    @bindEvents()

  bindEvents: ->
    @manager.globalBus.filter((ev) -> ev.type == 'SEND_MAP').onValue @sendMapToSocket
  generateMap: (map, width, height) ->
    debug('Generationg map')
    generator = new ROT.Map.Arena(width, height)
    generator.create (x, y, wall) ->
      map.push {x, y, wall}

  # Makes two dimensional map from one-dimensional map so that when y-coord changes, new row will be added.
  # Benefit with this method is that then you can access map's point with arrayedMap[x][y]
  makeTwoDimensionArrayFromMap: (map) ->
    debug('Generating two dimensional map')
    _.reduce(map, (acc, tile) ->
      lastAdded = _.last(_.last(acc))
      if _.isUndefined(lastAdded)
        _.last(acc).push(tile)
      else if tile.x == lastAdded.x
        _.last(acc).push(tile)
      else
        acc.push(Array(tile))
      acc
    , [[]])

  canMove: (x, y) ->
    @arrayedMap[x][y].wall == 0

  sendMapToSocket: (ev) =>
    debug("Sending map to socket #{ev.id}")
    @manager.globalBus.push { type: 'SEND_TO_SOCKET', id: ev.id, key: 'map', data: @map }

module.exports = MapActor