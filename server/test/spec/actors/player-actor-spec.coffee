should = require('should')
sinon = require('sinon')
_ = require('underscore')
Bacon = require('baconjs')

GameManager = require('../../../app/actors/game-manager')
PlayerActor = require('../../../app/actors/player-actor')
Factory = require('../factory')
random = require('../../../app/utils/random')

describe 'PlayerActor', ->
  beforeEach ->
    @gameManager = new GameManager(0)
    @clock = sinon.useFakeTimers(0)

    @oldBus = @gameManager.globalBus
    @gameManager.globalBus = new Bacon.Bus()

    @randomStub = sinon.stub random, "randomNumber"
    @randomStub.returns(0)
    @movePlayerSpy = sinon.spy PlayerActor.prototype, 'movePlayer'
    @rocketHitSpy = sinon.spy PlayerActor.prototype, 'rocketHit'
    @shootWithPlayerSpy = sinon.spy PlayerActor.prototype, 'shootWithPlayer'

    @playerActor = new PlayerActor(@gameManager, '123', "MANNY")

  afterEach ->
    @clock.restore()
    @gameManager.globalBus = @oldBus
    @randomStub.restore()
    @movePlayerSpy.restore()
    @rocketHitSpy.restore()
    @shootWithPlayerSpy.restore()

  it 'should push PLAYER_ADD event when it\'s created', (done) ->
    @gameManager.globalBus.filter((ev) -> ev.type == 'PLAYER_ADD').onValue -> done()
    new PlayerActor(@gameManager, "MANNY")

  it 'should push PLAYER_REMOVE event when it\'s removed', (done) ->
    @gameManager.globalBus.filter((ev) -> ev.type == 'PLAYER_REMOVE').onValue -> done()
    @playerActor.destroy()

  it 'should be correct type', ->
    @playerActor.type.should.be.eql('player')

  it 'should be able to give a state', ->
    state = @playerActor.getState()
    state.id.should.be.eql('123')
    state.x.should.be.eql(1)
    state.y.should.be.eql(1)
    state.health.should.be.eql(5)
    state.color.should.be.eql("red")
    state.name.should.be.eql("MANNY")

  it 'should respond to own player_move event', ->
    @gameManager.globalBus.push
      id: '123'
      type: 'PLAYER_MOVE'
    @movePlayerSpy.called.should.be.true

  it 'should not respond to other player_move event', ->
    @gameManager.globalBus.push
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
    @gameManager.globalBus.filter((ev) -> ev.type == 'BROADCAST').onValue -> done()
    @playerActor.destroy()

  it 'should broadcast player state changed when player is moving', (done) ->
    @gameManager.globalBus.filter((ev) -> ev.type == 'BROADCAST').onValue -> done()
    @playerActor.movePlayer
      direction: 'right'

  it 'should create rocket actor when player is shooting', ->
    @playerActor.shootWithPlayer
      direction: 'right'
    rocketActor = _.last @gameManager.actors
    rocketActor.type.should.be.eql('rocket')

  it 'should throttle rocket shootings', ->
    @gameManager.globalBus.push { type: "PLAYER_SHOOT", id: @playerActor.id }
    @gameManager.globalBus.push { type: "PLAYER_SHOOT", id: @playerActor.id }
    @shootWithPlayerSpy.callCount.should.be.eql(1)
    @clock.tick(@playerActor.shootCooldown)
    @gameManager.globalBus.push { type: "PLAYER_SHOOT", id: @playerActor.id }
    @shootWithPlayerSpy.callCount.should.be.eql(2)

  it 'should be able to be hit by rocket', ->
    rocket = Factory.rocketActor(
      gameManager: @gameManager,
      x: @playerActor.x,
      y: @playerActor.y + 1,
      direction: 'up')
    rocket.move()
    @rocketHitSpy.called.should.be.true

  it 'should reduce health when hit by rocket', ->
    rocket = Factory.rocketActor(
      gameManager: @gameManager,
      x: @playerActor.x,
      y: @playerActor.y + 1,
      direction: 'up')
    rocket.move()
    @playerActor.health.should.be.eql(4)

  it 'should broadcast player-state-changed when rocket is hit', (done) ->
    @gameManager.globalBus.filter((ev) -> ev.type == 'BROADCAST' && ev.key == "player-state-changed").onValue (ev) ->
      done()

    rocket = Factory.rocketActor(
      gameManager: @gameManager,
      x: @playerActor.x,
      y: @playerActor.y + 1,
      direction: 'up')
    rocket.move()

  it 'should die if health is reduced to zero', (done) ->
    @gameManager.globalBus.filter((ev) =>
      ev.type == 'PLAYER_DIE' && ev.player == @playerActor
    ).onValue (ev) ->
      done()

    rocket = Factory.rocketActor(
      gameManager: @gameManager,
      x: @playerActor.x,
      y: @playerActor.y + 1,
      direction: 'up')

    @playerActor.health = 1
    rocket.move()

  it 'should broadcast player-state-changed when dying', (done) ->
    @gameManager.globalBus.filter((ev) ->
      ev.type == 'BROADCAST' && ev.key == 'player-state-changed'
    ).onValue (ev) ->
      done()
    rocket = Factory.rocketActor(
      gameManager: @gameManager,
      x: @playerActor.x,
      y: @playerActor.y + 1,
      direction: 'up')

    @playerActor.health = 1
    rocket.move()

  it 'should broadcast a corpse add message when dying', (done) ->
    @gameManager.globalBus.filter((ev) =>
      ev.type == 'BROADCAST' && ev.key == 'new-corpse' &&
        ev.data.x == @playerActor.x && ev.data.y == @playerActor.y &&
        ev.data.color == @playerActor.color
    ).onValue (ev) ->
      done()
    rocket = Factory.rocketActor(
      gameManager: @gameManager,
      x: @playerActor.x,
      y: @playerActor.y + 1,
      direction: 'up')

    @playerActor.health = 1
    rocket.move()
