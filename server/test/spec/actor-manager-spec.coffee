should = require('should')
sinon = require('sinon')

describe 'ActorManager', ->
  beforeEach ->
    @actorManager = require('../../app/actors/actor-manager')

  it 'should have global bus', ->
    should.exist(@actorManager.globalBus)
  it 'should create map actor', ->
    @actorManager.createMapActor()
