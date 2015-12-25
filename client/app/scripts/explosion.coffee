class Explosion

  @color: '#ffffff'

  constructor: (@id, @x, @y) ->

  render: (display) ->
    console.log('render explosion', @id, @x, @y)
    renderOne = (x, y, symbol) ->
      display.draw(x, y, symbol, Explosion.color)

    renderOne(@x-1, @y-1, '/')
    renderOne(@x, @y-1, '-')
    renderOne(@x+1, @y-1, '\\')
    renderOne(@x-1, @y, '|')
    renderOne(@x+1, @y, '|')
    renderOne(@x-1, @y+1, '\\')
    renderOne(@x, @y+1, '-')
    renderOne(@x+1, @y+1, '/')

  tilesToReset: ->
    [
      [@x-1, @y-1],
      [@x, @y-1],
      [@x+1, @y-1],
      [@x-1, @y],
      [@x+1, @y],
      [@x-1, @y+1],
      [@x, @y+1],
      [@x+1, @y+1],
    ]

module.exports = Explosion
