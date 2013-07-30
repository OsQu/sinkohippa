should = require('should')
sinon = require('sinon')
SocketListener = require('../../app/socket-listener')
describe 'Socket', ->
  beforeEach ->
    @onSpy = sinon.spy()
    @mockSocket =
      emit: sinon.spy()
      join: sinon.spy()

    @mockIO =
      sockets:
        on: @onSpy
        in: => @mockSocket

    @socketListener = new SocketListener(@mockIO)
    @socketListener.startListening()

  afterEach ->
    @onSpy.reset()
  it 'should be initialized', ->
    should.exist(@socketListener)
  it 'should listen connections', ->
    @onSpy.called.should.be.true
    @onSpy.firstCall.args[0].should.eql('connection')

  describe 'When receiving connection', ->
    beforeEach ->
      @receivedCB = @onSpy.firstCall.args[1]
      @receivedCB(@mockSocket)

    it 'should reply back when receiving connection', ->
      @receivedCB.should.be.a('function')
      @mockSocket.emit.called.should.be.true

    it 'should add socket to the room "all"', ->
      @mockSocket.join.called.should.be.true
      @mockSocket.join.firstCall.args[0].should.eql('all')
