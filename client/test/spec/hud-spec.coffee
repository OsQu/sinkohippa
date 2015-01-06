expect = require('chai').expect
Bacon = require('baconjs')
Hud = require('../client/hud')
Player = require('../client/player')
gameEvents = require('../client/game-events')

describe 'HUD', ->
  beforeEach ->
    @oldBus = gameEvents.globalBus
    gameEvents.globalBus = new Bacon.Bus()

    # Construting mock hud
    @hudHtml = $('<div></div>')
    @hudHtml.append($('<b class="player-health"></b>'))
    $('body').append(@hudHtml)

    sinon.spy(Hud.prototype, 'updateHud')
    @hud = new Hud()

  afterEach ->
    gameEvents.globalBus = @oldBus
    Hud.prototype.updateHud.restore?()
    @hudHtml.remove()

  it 'should be not undefined', ->
    expect(@hud).to.be.not.undefined

  it 'should update hud after hud-event', ->
    player = new Player 'player-1', 100, 100
    player.health = 3
    gameEvents.globalBus.push { target: 'hud', data: player }
    expect(Hud.prototype.updateHud.called).to.be.true

  it 'should update player health', ->
    @hud.updateHud
      data:
        health: 2
    expect($('.player-health').html()).to.be.equals('2')

