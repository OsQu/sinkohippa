class Player
  constructor: (@name) ->
    @x = 0
    @y = 0

  getChar: ->
    '@'

  render: (display) ->
    display.draw(@x, @y, @getChar())


module.exports = Player
