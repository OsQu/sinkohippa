debug = require('debug')('sh:rocket-actor')

class RocketActor
  constructor: (@manager, @rocketId, @shooterId, @x, @y, @direction) ->
    @type = 'rocket'
    @speed = 200 # 200ms / square
    @startMoving()

  getState: ->
    state =
      shooter: @shooterId
      x: @x
      y: @y
      direction: @direction
    state

  startMoving: ->
    @intervalId = setInterval(@move, @speed)

  stopMoving: ->
    clearInterval(@intervalId)

  move: =>
    switch @direction
      when 'up' then @y--
      when 'down' then @y++
      when 'left' then @x--
      when 'right' then @x++
    @manager.globalBus.push { type: 'ROCKET_MOVED', rocketId: @rocketId, x: @x, y: @y }
    debug("Moved rocket #{@rocketId}")

module.exports = RocketActor
