should = require('should')
sinon = require('sinon')
socketListener = require('../../app/socket-listener')
gameController = require('../../app/game-controller')

describe 'Socket', ->
  beforeEach ->
    @socketsOnSpy = sinon.spy()
    socketsEmitSpy = sinon.spy()
    @mockSocket =
      emit: sinon.spy()
      join: sinon.spy()
      on: sinon.spy()
      id: 'socket-1'

    @mockIO =
      sockets:
        on: @socketsOnSpy
        in: ->
          emit: socketsEmitSpy

    socketListener(@mockIO)

  afterEach ->
    @mockSocket.emit.reset()
    @mockSocket.join.reset()
    @mockSocket.on.reset()
    @socketsOnSpy.reset()
    @mockIO.sockets.in().emit.reset()

    gameController.players = []

  it 'should listen connections', ->
    @socketsOnSpy.called.should.be.true
    @socketsOnSpy.firstCall.args[0].should.eql('connection')

  describe 'when receiving connection', ->
    beforeEach ->
      @receivedCB = @socketsOnSpy.firstCall.args[1]
      @receivedCB(@mockSocket)

    it 'should add socket to the room "all"', ->
      @mockSocket.join.called.should.be.true
      @mockSocket.join.firstCall.args[0].should.eql('all')

    it 'should send map to socket', ->
      @mockSocket.emit.firstCall.args[0].should.be.eql('map')
      @mockSocket.emit.firstCall.args[1].length.should.be.above(0)

    it 'should add player to game-controller', ->
      gameController.players.length.should.be.above(0)
      gameController.players[0].id.should.be.eql(@mockSocket.id)

    it 'should broadcast state after player-event', ->
      socketOnCB = @mockSocket.on.firstCall.args[1]
      socketOnCB 'player',
        action: 'move'
        direction: 'up'
      @mockIO.sockets.in().emit.called.should.be.true
      @mockIO.sockets.in().emit.firstCall.args[0].should.be.eql('state')

