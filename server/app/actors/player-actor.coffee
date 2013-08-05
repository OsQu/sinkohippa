debug = require('debug')('sh:player-actor')

class PlayerActor
  constructor: (@manager, @id) ->
    @type = 'player'
    @x = 1
    @y = 1
    @health = 5
    @manager.globalBus.push { type: 'BROADCAST', key: 'new-player', data: @getState() }

    @bindEvents()

  bindEvents: ->
    @unsubscribeMovePlayer = @manager.globalBus.filter((ev) => ev.id == @id).filter((ev) => ev.type == 'PLAYER_MOVE').onValue @movePlayer
    @unsubscribeShoot = @manager.globalBus.filter((ev) => ev.id == @id).filter((ev) => ev.type == 'PLAYER_SHOOT').onValue @shootWithPlayer
    @unsubscribeRocketMoved = @manager.globalBus.filter((ev) => ev.type == 'ROCKET_MOVED').filter((ev) => ev.x == @x && ev.y == @y).onValue @rocketHit

  destroy: ->
    @manager.globalBus.push { type: 'BROADCAST', key: 'player-leaving', data: @id }
    @unsubscribeMovePlayer()
    @unsubscribeShoot()
    @unsubscribeRocketMoved()

  getState: ->
    state =
      id: @id
      x: @x
      y: @y
      health: @health
    state

  movePlayer: (ev) =>
    debug "Moving player #{@id}"
    mapActor = @manager.getMapActor()
    switch ev.direction
      when 'up' then if mapActor.canMove(@x, @y - 1) then @y--
      when 'down' then if mapActor.canMove(@x, @y + 1) then @y++
      when 'left' then if mapActor.canMove(@x - 1, @y) then @x--
      when 'right' then if mapActor.canMove(@x + 1, @y) then @x++

    @manager.globalBus.push { type: 'BROADCAST', key: 'player-state-changed', data: @getState() }

  shootWithPlayer: (ev) =>
    debug "Player #{@id} is shooting"
    @manager.createRocketActor(@id, @x, @y, ev.direction)

  rocketHit: (ev) =>
    debug "Player #{@id} got hit by rocket #{ev.rocketId}"
    @manager.deleteRocketActor(ev.rocketId)

module.exports = PlayerActor
