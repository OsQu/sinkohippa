define ['rot', 'tile'], (ROT, Tile) ->
  class Map
    constructor: (@width, @height) ->
      @tiles = []

    generate: () ->
      generator = new ROT.Map.Arena(80, 25)
      generator.create (x,y, wall) =>
        @tiles.push new Tile x, y, wall

    getTiles: () -> # Terrible
      @tile

    render: (display) =>
      _.each @tiles, (tile) =>
        display.draw tile.x, tile.y, tile.getChar()
