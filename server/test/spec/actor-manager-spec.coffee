should = require('should')
sinon = require('sinon')
_ = require('underscore')
Bacon = require('baconjs')

SocketActor = require('../../app/actors/socket-actor')

describe 'ActorManager', ->
  beforeEach ->
    @actorManager = require('../../app/actors/actor-manager')
    @oldBus = @actorManager.globalBus
    @actorManager.globalBus = new Bacon.Bus()

  afterEach ->
    SocketActor.prototype.broadcast.restore?()

  it 'should have global bus', ->
    should.exist(@actorManager.globalBus)

  it 'should create map actor on startup', ->
    _.some(@actorManager.actors, (a) -> a.type == 'map').should.be.true

  it 'should create socket actor on startup', ->
    _.some(@actorManager.actors, (a) -> a.type == 'socket').should.be.true

  it 'should be able to give map actor', ->
    should.exist(@actorManager.getMapActor())

  it 'should be able to give state', ->
    @actorManager.createPlayerActor('123')
    state = @actorManager.getGameState()
    state[0].type.should.be.eql('map')
    state[0].state.should.be.instanceOf(Array)
    state[1].type.should.be.eql('player')
    state[1].state.id.should.be.eql('123')
    state[1].state.x.should.be.eql(1)
    state[1].state.y.should.be.eql(1)

  describe 'actor creation', ->
    beforeEach ->
      @oldActors = @actorManager.actors
      @actorManager.actors = []

    afterEach ->
      @actorManager.actors = @oldActors

    it 'should be able to create map actor', ->
      @actorManager.createMapActor()
      @actorManager.actors[0].type.should.be.eql('map')

    it 'should be able to create socket actor', ->
      @actorManager.createSocketActor()
      @actorManager.actors[0].type.should.be.eql('socket')

    it 'should be able to create player actor', ->
      @actorManager.createPlayerActor('123')
      @actorManager.actors[0].type.should.be.eql('player')

    it 'should be able to create rocket actor', ->
      @actorManager.createRocketActor('shooter-1', 1, 4, 'up')
      @actorManager.actors[0].type.should.be.eql('rocket')
      @actorManager.actors[0].shooterId.should.be.eql('shooter-1')

    it 'should be able to delete player actor', ->
      @actorManager.createPlayerActor('123')
      @actorManager.createPlayerActor('321')
      @actorManager.actors.length.should.be.eql(2)

      deleteActor = @actorManager.actors[0]
      deleteActor.destroy = sinon.spy()
      @actorManager.deletePlayerActor('123')
      @actorManager.actors.length.should.be.eql(1)
      deleteActor.destroy.called.should.be.true
