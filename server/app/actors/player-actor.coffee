debug = require('debug')('sh:player-actor')
_ = require('underscore')

random = require("../utils/random")

PLAYER_COLORS = ["red", "blue", "green", "yellow", "white"]

class PlayerActor
  constructor: (@manager, @id) ->
    @type = 'player'
    # TODO: Refactor these to use map constants
    @x = random.randomNumber(78) + 1
    @y = random.randomNumber(23) + 1
    @color = PLAYER_COLORS[@manager.players().length % PLAYER_COLORS.length]
    @health = 5
    @shootCooldown = 500
    @manager.globalBus.push { type: 'BROADCAST', key: 'new-player', data: @getState() }
    @manager.globalBus.push { type: 'PLAYER_ADD', player: @ }

    @bindEvents()

  bindEvents: ->
    @unsubscribeMovePlayer = @manager.globalBus.filter((ev) => ev.id == @id).filter((ev) => ev.type == 'PLAYER_MOVE').onValue @movePlayer
    @unsubscribeShoot = @manager.globalBus.filter((ev) => ev.id == @id).filter((ev) => ev.type == 'PLAYER_SHOOT').debounceImmediate(@shootCooldown).onValue @shootWithPlayer
    @unsubscribeRocketMoved = @manager.globalBus.filter((ev) => ev.type == 'ROCKET_MOVED').filter((ev) => ev.x == @x && ev.y == @y).onValue @rocketHit

  destroy: ->
    @manager.globalBus.push { type: 'BROADCAST', key: 'player-leaving', data: @id }
    @manager.globalBus.push { type: 'PLAYER_REMOVE', player: @ }
    @unsubscribeMovePlayer()
    @unsubscribeShoot()
    @unsubscribeRocketMoved()

  getState: ->
    state =
      id: @id
      x: @x
      y: @y
      color: @color
      health: @health
    state


  broadcastStateChanged: ->
    @manager.globalBus.push { type: 'BROADCAST', key: 'player-state-changed', data: @getState() }

  movePlayer: (ev) =>
    debug "Moving player #{@id}"
    mapActor = @manager.getMapActor()
    switch ev.direction
      when 'up' then if mapActor.canMove(@x, @y - 1) then @y--
      when 'down' then if mapActor.canMove(@x, @y + 1) then @y++
      when 'left' then if mapActor.canMove(@x - 1, @y) then @x--
      when 'right' then if mapActor.canMove(@x + 1, @y) then @x++
    @broadcastStateChanged()

  shootWithPlayer: (ev) =>
    debug "Player #{@id} is shooting"
    @manager.createRocketActor(@id, @x, @y, ev.direction)

  rocketHit: (ev) =>
    debug "Player #{@id} got hit by rocket #{ev.rocket.id}"
    @manager.deleteRocketActor(ev.rocket.id)
    @health = @health - ev.damage
    debug "Reduced player #{@id} health to #{@health}"
    if @health <= 0 then @die(ev.rocket)
    @broadcastStateChanged()

  die: (rocket) ->
    debug "Crap! (For player #{@id}). It died :("
    @x = random.randomNumber(78) + 1
    @y = random.randomNumber(23) + 1
    @health = 5
    @manager.globalBus.push { type: 'PLAYER_DIE', player: @, rocket: rocket }

module.exports = PlayerActor
