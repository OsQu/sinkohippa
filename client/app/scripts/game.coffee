define ['jquery', 'underscore', 'rot', 'map'], ($, _, ROT, Map) ->
  class Game
    init: ->
      @display = new ROT.Display()
      @map = new Map()
      @map.generate()

      $('#game-container').append(@display.getContainer())

    render: ->
      @map.render(@display)
