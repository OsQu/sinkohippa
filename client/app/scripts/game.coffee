define ['jquery', 'underscore', 'rot'], ($, _, ROT) ->
  class Tile
    constructor: (@x, @y, @type) ->

    getChar: =>
      if @type then '#' else '.'

  class Game
    init: ->
      @display = new ROT.Display()
      @mapGenerator = new ROT.Map.Arena(80, 25)
      @map = []
      $('#game-container').append(@display.getContainer())
      @mapGenerator.create(@storeArena)

    storeArena: (x, y, wall) =>
      @map.push(new Tile x, y, wall)

    render: =>
      _.each @map, (tile) =>
        @display.draw tile.x, tile.y, tile.getChar()
