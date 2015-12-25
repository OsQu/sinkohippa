class MapDisplay
  constructor: (@display, @dimensions) ->

  draw: (x, y, rest...) ->
    if x < @dimensions.width && y < @dimensions.height
      @display.draw x, y, rest...

module.exports = MapDisplay
