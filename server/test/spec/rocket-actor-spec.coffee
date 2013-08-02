should = require('should')
sinon = require('sinon')
_ = require('underscore')
Bacon = require('baconjs')

actorManager = require('../../app/actors/actor-manager')
RocketActor = require('../../app/actors/rocket-actor')

describe 'RocketActor', ->
  beforeEach ->
    @oldBus = actorManager.globalBus
    actorManager.globalBus = new Bacon.Bus()

    @rocketActor = new RocketActor(actorManager, 'rocket-1', '123', 5, 4, 'right')

  afterEach ->
    actorManager.globalBus = @oldBus

  it 'should be a correct type', ->
    @rocketActor.type.should.be.eql('rocket')

  it 'should give current state', ->
    state = @rocketActor.getState()
    state.shooter.should.be.eql('123')
    state.x.should.be.eql(5)
    state.y.should.be.eql(4)
    state.direction.should.be.eql('right')
