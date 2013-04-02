define [], () ->
  class Tile
    constructor: (@x, @y, @type) ->

    getChar: =>
      if @type then '#' else '.'
