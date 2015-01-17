expect = require('chai').expect
ROT = require("../../client/vendor/rot.js/rot")
sinon = require('sinon')

Hud = require("../../client/ui/hud")
Player = require('../../client/player')
gameEvents = require("../../client/game-events")
require("../mocks")["mockGameEvents"]()

describe 'Hud', ->

  beforeEach ->
    @display = new ROT.Display()
    @hud = new Hud(display: @display, location: { x: 0, y: 0 })

  it "renders health", ->
    sinon.stub(@display, "drawText")
    player = new Player 'player-1', "red", 100, 100
    player.health = 3
    gameEvents.globalBus.push { target: 'hud', data: player }
    expect(@display.drawText.calledWith(0,0,"HP:3")).to.be.true
