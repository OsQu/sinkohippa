should = require('should')
sinon = require('sinon')
_ = require('underscore')
Bacon = require('baconjs')

SocketActor = require('../../../app/actors/socket-actor')
GameManager = require('../../../app/actors/game-manager')

mockSocketCreator = require('../spec-helpers').createMockSocket

describe 'ActorManager', ->
  beforeEach ->
    @gameManager = new GameManager(0)
    @oldBus = @gameManager.globalBus
    @gameManager.globalBus = new Bacon.Bus()

  afterEach ->
    @gameManager.rocketCount = 0
    SocketActor.prototype.broadcast.restore?()

  it 'should have id', ->
    @gameManager.id.should.be.eql(0)

  it 'should have global bus', ->
    should.exist(@gameManager.globalBus)

  it 'should create map actor on startup', ->
    _.some(@gameManager.actors, (a) -> a.type == 'map').should.be.true

  it 'should create socket actor on startup', ->
    _.some(@gameManager.actors, (a) -> a.type == 'socket').should.be.true

  it 'should be able to give map actor', ->
    should.exist(@gameManager.getMapActor())

  it 'should be able to give state', ->
    @gameManager.createPlayerActor('123')
    state = @gameManager.getGameState()
    state[0].type.should.be.eql('map')
    state[0].state.should.be.instanceOf(Array)
    state[1].type.should.be.eql('player')
    state[1].state.id.should.be.eql('123')
    state[1].state.x.should.exist
    state[1].state.y.should.exist

  it 'should be able to fetch socket actor', ->
    @gameManager.getSocketActor().should.be.defined

  it 'should be able to add player', ->
    mockSocket = mockSocketCreator('socket-1')
    @gameManager.addPlayer(mockSocket)
    _.find(@gameManager.actors, (a) -> a.type == 'player').should.be.defined

  describe 'actor creation', ->
    beforeEach ->
      @oldActors = @gameManager.actors
      @gameManager.actors = []

    afterEach ->
      @gameManager.actors = @oldActors

    it 'should be able to create map actor', ->
      @gameManager.createMapActor()
      @gameManager.actors[0].type.should.be.eql('map')

    it 'should be able to create socket actor', ->
      @gameManager.createSocketActor()
      @gameManager.actors[0].type.should.be.eql('socket')

    it 'should be able to create player actor', ->
      @gameManager.createPlayerActor('123')
      @gameManager.actors[0].type.should.be.eql('player')

    it 'should be able to create rocket actor', ->
      @gameManager.createRocketActor('shooter-1', 1, 4, 'up')
      @gameManager.actors[0].type.should.be.eql('rocket')
      @gameManager.actors[0].shooterId.should.be.eql('shooter-1')

    it 'should be able to delete player actor', ->
      @gameManager.createPlayerActor('123')
      @gameManager.createPlayerActor('321')
      @gameManager.actors.length.should.be.eql(2)

      deleteActor = @gameManager.actors[0]
      deleteActor.destroy = sinon.spy()
      @gameManager.deletePlayerActor('123')
      @gameManager.actors.length.should.be.eql(1)
      deleteActor.destroy.called.should.be.true

    it 'should be able to delete rocket actor', ->
      @gameManager.createRocketActor('shooter-1', 1, 4, 'up')
      @gameManager.createRocketActor('shooter-2', 2, 6, 'right')
      @gameManager.actors.length.should.be.eql(2)
      deleteActor = @gameManager.actors[0]
      deleteActor.destroy = sinon.spy()
      @gameManager.deleteRocketActor(0)
      @gameManager.actors.length.should.be.eql(1)
      deleteActor.destroy.called.should.be.true

    it "should broadcast game-destroyed when last player leaves", (done) ->
      @gameManager.globalBus.filter((ev) -> ev.type == 'BROADCAST' && ev.key == "game-destroyed")
        .take(1)
        .onValue (ev) =>
          ev.data.should.be.eql(@gameManager.id)
          done()

      @gameManager.createPlayerActor("1")
      @gameManager.createPlayerActor("2")
      @gameManager.deletePlayerActor("1")
      @gameManager.deletePlayerActor("2")

    it "should be able to give player count", ->
      @gameManager.createPlayerActor('1')
      @gameManager.createPlayerActor('2')
      @gameManager.playerCount().should.be.eql(2)
