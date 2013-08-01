should = require('should')
sinon = require('sinon')
_ = require('underscore')

SocketActor = require('../../app/actors/socket-actor')

describe 'ActorManager', ->
  beforeEach ->
    sinon.stub(SocketActor.prototype, 'broadcast')
    @actorManager = require('../../app/actors/actor-manager')

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

  describe 'actor creation', ->
    beforeEach ->
      @actorManager.actors = []

    it 'should be able to create map actor', ->
      @actorManager.createMapActor()
      @actorManager.actors[0].type.should.be.eql('map')

    it 'should be able to create socket actor', ->
      @actorManager.createSocketActor()
      @actorManager.actors[0].type.should.be.eql('socket')

    it 'should be able to create player actor', ->
      @actorManager.createPlayerActor('123')
      @actorManager.actors[0].type.should.be.eql('player')

    it 'should be able to delete player actor', ->
      @actorManager.createPlayerActor('123')
      @actorManager.createPlayerActor('321')
      @actorManager.actors.length.should.be.eql(2)

      deleteActor = @actorManager.actors[0]
      deleteActor.destroy = sinon.spy()
      @actorManager.deletePlayerActor('123')
      @actorManager.actors.length.should.be.eql(1)
      deleteActor.destroy.called.should.be.true
