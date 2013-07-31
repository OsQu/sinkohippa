debug = require('debug')('sh:game-controller')
ROT = require('./vendor/rot.js/rot')
_ = require('underscore')

class GameController
  constructor: ->
    @map = []
    @mapWidth = 80
    @mapHeight = 25
    @generateMap(@map, @mapWidth, @mapHeight)
    @arrayedMap = @makeTwoDimensionArrayFromMap(@map)
    @players = []
    debug('Map ready')

  generateMap: (map, width, height) ->
    debug('Generationg map')
    generator = new ROT.Map.Arena(width, height)
    generator.create (x, y, wall) ->
      map.push {x, y, wall}

  # Makes two dimensional map from array so that when y-coord changes, new row will be added to array.
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

  getMap: -> @map

  getGameState: ->
    state =
      players: @players
      map: @map

  addPlayer: (id) ->
    player =
      id: id
      x: 1
      y: 1
    @players.push(player)

  removePlayer: (id) ->
    @players = _.filter @players, (p) -> p.id != id

  canMove: (player, x, y) ->
    @arrayedMap[x][y].wall == 0

  movePlayer: (playerId, direction) ->
    player = _.find @players, (p) -> p.id == playerId
    if player
      switch direction
        when 'up' then if @canMove(player, player.x, player.y - 1) then player.y--
        when 'down' then if @canMove(player, player.x, player.y + 1) then player.y++
        when 'left' then if @canMove(player, player.x - 1, player.y) then player.x--
        when 'right' then if @canMove(player, player.x + 1, player.y) then player.x++
      debug 'Player moved'
    else
      debug 'Player not found :('


instance = new GameController()
module.exports = instance

