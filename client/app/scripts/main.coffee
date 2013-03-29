console.log "Real mainjs"
require ['jquery', 'game', 'bootstrap'],  ($, Game) ->
    'use strict'
    sinkohippa = new Game
    sinkohippa.init()
    sinkohippa.render()
