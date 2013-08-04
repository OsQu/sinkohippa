class Rocket
  constructor: (@id, @x, @y, @shooter, @direction) ->

  getChar: ->
    if @direction == 'up' || @direction == 'down'
      '|'
    else
      '-'

  render: (display) ->
    @handleNewPosition(display)
    display.draw(@x, @y, @getChar())

  clearCurrentPosition: (display) ->
    display.draw(@x, @y, '.')

  handleNewPosition: (display) ->
    if @newX or @newY
      @clearCurrentPosition(display)
      @x = @newX
      @y = @newY
      delete @newX
      delete @newY

module.exports = Rocket
