should = require('should')
sinon = require('sinon')
socketListener = require('../../app/socket-listener')
describe 'Socket', ->
  beforeEach ->
    @socketsOnSpy = sinon.spy()
    @mockSocket =
      emit: sinon.spy()
      join: sinon.spy()
      on: sinon.spy()

    @mockIO =
      sockets:
        on: @socketsOnSpy
        in: => @mockSocket

    socketListener(@mockIO)

  afterEach ->
    @socketsOnSpy.reset()
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
