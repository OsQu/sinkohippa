should = require('should')
sinon = require('sinon')
_ = require('underscore')
Bacon = require('baconjs')

actorManager = require('../../app/actors/actor-manager')
PlayerActor = require('../../app/actors/player-actor')

describe 'PlayerActor', ->
  beforeEach ->
    @oldBus = actorManager.globalBus
    actorManager.globalBus = new Bacon.Bus()

    @movePlayerSpy = sinon.spy PlayerActor.prototype, 'movePlayer'
    @rocketHitSpy = sinon.spy PlayerActor.prototype, 'rocketHit'

    @playerActor = new PlayerActor(actorManager, '123')

  afterEach ->
    actorManager.globalBus = @oldBus
    @movePlayerSpy.restore()
    @rocketHitSpy.restore()

  it 'should be correct type', ->
    @playerActor.type.should.be.eql('player')

  it 'should be able to give a state', ->
    state = @playerActor.getState()
    state.id.should.be.eql('123')
    state.x.should.be.eql(1)
    state.y.should.be.eql(1)
    state.health.should.be.eql(5)

  it 'should respond to own player_move event', ->
    actorManager.globalBus.push
      id: '123'
      type: 'PLAYER_MOVE'
    @movePlayerSpy.called.should.be.true

  it 'should not respond to other player_move event', ->
    actorManager.globalBus.push
      id: '321'
      type: 'PLAYER_MOVE'
    @movePlayerSpy.called.should.be.false

  it 'should be able to move player', ->
    @playerActor.x.should.be.eql(1)
    @playerActor.y.should.be.eql(1)
    @playerActor.movePlayer
      direction: 'down'
    @playerActor.x.should.be.eql(1)
    @playerActor.y.should.be.eql(2)

  it 'should not move player if it isn\'t possible', ->
    @playerActor.x.should.be.eql(1)
    @playerActor.y.should.be.eql(1)
    @playerActor.movePlayer
      direction: 'up'
    @playerActor.x.should.be.eql(1)
    @playerActor.y.should.be.eql(1)

  it 'should broadcast player leaving when destroying actor', (done) ->
    actorManager.globalBus.filter((ev) -> ev.type == 'BROADCAST').onValue -> done()
    @playerActor.destroy()

  it 'should broadcast player state changed when player is moving', (done) ->
    actorManager.globalBus.filter((ev) -> ev.type == 'BROADCAST').onValue -> done()
    @playerActor.movePlayer
      direction: 'right'

  it 'should create rocket actor when player is shooting', ->
    @playerActor.shootWithPlayer
      direction: 'right'
    rocketActor = _.last actorManager.actors
    rocketActor.type.should.be.eql('rocket')

  it 'should be able to hit player with rocket', ->
    actorManager.globalBus.push { type: 'ROCKET_MOVED', x: @playerActor.x, y: @playerActor.y }
    @rocketHitSpy.called.should.be.true
