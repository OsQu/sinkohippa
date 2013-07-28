'use strict'

console.log "Real mainjs"
Game = require('./game')
Player = require('./player')

player = new Player('Manny')

sinkohippa = new Game
sinkohippa.init()

sinkohippa.addPlayer(player)

sinkohippa.start()
