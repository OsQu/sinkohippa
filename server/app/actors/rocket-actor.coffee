debug = require('debug')('sh:rocket-actor')

class RocketActor
  constructor: (@manager, @id, @shooterId, @x, @y, @direction) ->
    @type = 'rocket'
    @speed = 200 # 200ms / square
    @startMoving()

  getState: ->
    state =
      shooter: @shooterId
      id: @id
      x: @x
      y: @y
      direction: @direction
    state

  destroy: ->
    @manager.globalBus.push { type: 'BROADCAST', key: 'rocket-destroyed', data: @getState() }
    debug("Destroying rocket #{@id}")
    @stopMoving()

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
    @manager.globalBus.push { type: 'ROCKET_MOVED', rocketId: @id, x: @x, y: @y }
    @manager.globalBus.push { type: 'BROADCAST', key: 'rocket-moved', data: @getState() }
    debug("Moved rocket #{@id}")

module.exports = RocketActor
