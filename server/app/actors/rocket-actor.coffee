debug = require('debug')('sh:rocket-actor')

class RocketActor
  constructor: (@manager, @rocketId, @shooterId, @x, @y, @direction) ->
    @type = 'rocket'

  bindEvents: ->

  getState: ->
    state =
      shooter: @shooterId
      x: @x
      y: @y
      direction: @direction
    state

module.exports = RocketActor
