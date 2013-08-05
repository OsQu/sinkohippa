'use strict'

console.log "Real mainjs"
Game = require('./game')
Hud = require('./hud')

hud = new Hud()

sinkohippa = new Game
sinkohippa.init()

sinkohippa.start()

