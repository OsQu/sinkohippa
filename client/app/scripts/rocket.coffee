class Rocket
  constructor: (@id, @x, @y, @shooter, @direction) ->

  getChar: ->
    if @direction == 'up' || @direction == 'down'
      '|'
    else
      '-'

  render: (display) ->
    display.draw(@x, @y, @getChar(), @shooter?.colorCode())

  clearCurrentPosition: (display) ->
    display.draw(@x, @y, '.')

  tilesToReset: ->
    [[@x, @y]]

module.exports = Rocket
