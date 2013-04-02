console.log "Real mainjs"
require ['jquery', 'bacon', 'game', 'bootstrap'],  ($, Bacon, Game) ->
    'use strict'

    sinkohippa = new Game
    sinkohippa.init()
    sinkohippa.start()
