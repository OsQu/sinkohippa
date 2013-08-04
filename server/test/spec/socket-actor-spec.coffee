should = require('should')
sinon = require('sinon')
_ = require('underscore')
Bacon = require('baconjs')

actorManager = require('../../app/actors/actor-manager')
SocketActor = require('../../app/actors/socket-actor')

describe 'SocketActor', ->
  beforeEach ->
    @io =
      sockets:
        on: ->
        in: ->
          emit: ->

    @socket =
      join: sinon.spy()
      emit: sinon.spy()
      on: sinon.spy()

    @oldBus = actorManager.globalBus
    actorManager.globalBus = new Bacon.Bus()

    @startListeningSocketsSpy = sinon.spy SocketActor.prototype, 'startListeningSockets'
    @sendToSocketSpy = sinon.spy SocketActor.prototype, 'sendToSocket'
    @broadcastSpy = sinon.spy SocketActor.prototype, 'broadcast'
    @deletePlayerActorStub = sinon.stub actorManager, 'deletePlayerActor'

    @socketActor = new SocketActor(actorManager)
    @socketActor.io = @io

  afterEach ->
    actorManager.globalBus = @oldBus
    @startListeningSocketsSpy.restore()
    @sendToSocketSpy.restore()
    @broadcastSpy.restore()
    @socket.join.reset()
    @socket.emit.reset()
    @socket.on.reset()
    @deletePlayerActorStub.restore()

  it 'should be a correct type', ->
    @socketActor.type.should.be.eql('socket')

  it 'should start listening sockets when start-listening-sockets event is triggered', ->
    actorManager.globalBus.push
      io: @io
      type: 'START_LISTENING_SOCKETS'

    @startListeningSocketsSpy.called.should.be.true

  it 'should send event to socket when send-to-socket event is triggered', ->
    actorManager.globalBus.push
      id: '123'
      key: 'test'
      data: 'testData'
      type: 'SEND_TO_SOCKET'

    @sendToSocketSpy.called.should.be.true

  it 'should send broadcast when broadcast-event is triggered', ->
    actorManager.globalBus.push
      key: 'test'
      data: 'testData'
      type: 'BROADCAST'

    @broadcastSpy.called.should.be.true

  it 'should bind socket event to bacon stream', (done) ->
    mockSocket =
      on: sinon.spy()
    @socketActor.bind(mockSocket, 'event-key').onValue (ev) ->
      ev.data.should.be.eql('data')
      ev.socket.should.be.eql(mockSocket)
      ev.key.should.be.eql('event-key')
      done()

    onCb = mockSocket.on.firstCall.args[1]
    onCb('data')

  it 'should give state', ->
    should.exist(@socketActor.getState())

  it 'should handle disconnection', ->
    @socketActor.handleDisconnection
      socket:
        id: 123
    @deletePlayerActorStub.called.should.be.true

  describe 'receive player event', ->
    it 'should push PLAYER_MOVE event to globalBus when player-move-event is received', (done) ->
      actorManager.globalBus.filter((ev) -> ev.type == 'PLAYER_MOVE').onValue (ev) ->
        ev.direction.should.be.eql('up')
        ev.id.should.be.eql('123')
        done()

      @socketActor.handlePlayerEvent
        data:
          action: 'move'
          direction: 'up'
        socket:
          id: '123'

  describe 'new connection', ->
    beforeEach ->
      @socketActor.newConnection(@socket)

    it 'should add socket to sockets array', ->
      @socketActor.sockets.length.should.be.eql(1)

    it 'should add socket to "all" room', ->
      @socket.join.called.should.be.true
      @socket.join.firstCall.args[0].should.be.eql('all')

    it 'should emit game state to socket', ->
      @socket.emit.called.should.be.true
      @socket.emit.firstCall.args[0].should.be.eql('game-state')

    it 'should listen player event from socket', ->
      @socket.on.firstCall.args[0].should.be.eql('player')

    it 'should listen disconnect event from socket', ->
      @socket.on.secondCall.args[0].should.be.eql('disconnect')
