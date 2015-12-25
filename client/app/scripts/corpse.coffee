colors = require('./colors')

class Corpse
  constructor: (@x, @y, @color) ->

  render: (display) ->
    display.draw(@x, @y, '%', @colorCode())

  colorCode: ->
    colors(@color)


module.exports = Corpse
