colors = require('./colors')

class Corpse
  constructor: (@x, @y, @color) ->

  render: (display) ->
    console.log('Rendering corpse', @x, @y, @color)
    display.draw(@x, @y, '%', @colorCode())

  colorCode: ->
    colors(@color)


module.exports = Corpse
