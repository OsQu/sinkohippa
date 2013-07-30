debug = require('debug')('sh:game-controller')
ROT = require('./vendor/rot.js/rot')
_ = require('underscore')

class GameController
  constructor: ->
    @map = []
    @mapWidth = 80
    @mapHeight = 25
    @generateMap(@map, @mapWidth, @mapHeight)
    @players = []
    debug('Map ready')

  generateMap: (map, width, height) ->
    debug('Generationg map')
    generator = new ROT.Map.Arena(width, height)
    generator.create (x, y, wall) ->
      map.push {x, y, wall}

  getMap: -> @map

  getGameState: ->
    state =
      players: _.map(@players, (p) -> _.omit(p, 'id'))
      map: @map

  addPlayer: (id) ->
    player =
      id: id
      x: 0
      y: 0
    @players.push(player)

  removePlayer: (id) ->
    @players = _.filter @players, (p) -> p.id != id

  movePlayer: (playerId, direction) ->
    player = _.find @players, (p) -> p.id == playerId
    if player
      switch direction
        when 'up' then player.y--
        when 'down' then player.y++
        when 'left' then player.x--
        when 'right' then player.x++
      debug 'Player moved'
    else
      debug 'Player not found :('


instance = new GameController()
module.exports = instance

