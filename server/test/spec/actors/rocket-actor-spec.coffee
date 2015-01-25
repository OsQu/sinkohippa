should = require('should')
sinon = require('sinon')
_ = require('underscore')
Bacon = require('baconjs')

gameManager = require('../../../app/actors/game-manager')
RocketActor = require('../../../app/actors/rocket-actor')

describe 'RocketActor', ->
  beforeEach ->
    @clock = sinon.useFakeTimers(0)
    @oldBus = gameManager.globalBus
    gameManager.globalBus = new Bacon.Bus()

    @rocketActor = new RocketActor(gameManager, 'rocket-1', '123', 5, 4, 'right')

  afterEach ->
    @clock.restore()
    gameManager.globalBus = @oldBus

  it 'should be a correct type', ->
    @rocketActor.type.should.be.eql('rocket')

  it 'should give current state', ->
    state = @rocketActor.getState()
    state.shooter.should.be.eql('123')
    state.x.should.be.eql(5)
    state.y.should.be.eql(4)
    state.direction.should.be.eql('right')
    state.damage.should.be.eql(1)

  it 'should have rocket speed', ->
    should.exist(@rocketActor.speed)

  it 'should create interval to move the rocket when rocket is created', ->
    should.exist(@rocketActor.intervalId)

  it 'should move rocket to correct direction', ->
    @rocketActor.move()
    @rocketActor.x.should.be.eql(6)

  it 'should move rocket with setInterval', ->
    @rocketActor.x.should.be.eql(5)
    @clock.tick(@rocketActor.speed)
    @rocketActor.x.should.be.eql(6)
    @clock.tick(@rocketActor.speed)
    @rocketActor.x.should.be.eql(7)

  it 'should emit rocket-moved event when moving the rocket', (done) ->
    gameManager.globalBus.filter((ev) -> ev.type == 'ROCKET_MOVED').onValue (ev) =>
      ev.rocket.should.be.eql(@rocketActor)
      ev.x.should.be.eql(6)
      ev.y.should.be.eql(4)
      ev.damage.should.be.eql(1)
      done()

    @rocketActor.move()

  it 'should broadcast rocket-moving when rocket is moving', (done) ->
    gameManager.globalBus.filter((ev) -> ev.type == 'BROADCAST').onValue (ev) ->
      ev.key.should.be.eql('rocket-moved')
      done()
    @rocketActor.move()

  it 'should be able to stop rocket', ->
    @rocketActor.x.should.be.eql(5)
    @clock.tick(@rocketActor.speed)
    @rocketActor.x.should.be.eql(6)
    @rocketActor.stopMoving()
    @clock.tick(@rocketActor.speed)
    @rocketActor.x.should.be.eql(6)

  it 'should be able to destroy rocket', (done) ->
    gameManager.globalBus.filter((ev) -> ev.type == 'BROADCAST').onValue (ev) ->
      ev.key.should.be.eql('rocket-destroyed')
      done()
    @rocketActor.destroy()

  it 'should broadcast rocket-destroyed event when rocket is destroyed', (done) ->
    gameManager.globalBus.filter((ev) -> ev.type == 'BROADCAST').onValue (ev) ->
      ev.key.should.be.eql('rocket-destroyed')
      done()
    @rocketActor.destroy()
