should = require('should')
sinon = require('sinon')
describe 'Socket', ->
  beforeEach ->
    @onSpy = sinon.spy()
    @mockIO =
      sockets:
        on: @onSpy
    @socket = require('../../socket')

  afterEach ->
    @onSpy.reset()
  it 'should be initialized', ->
    should.exist(@socket)
  it 'should listen connections', ->
    @socket(@mockIO)
    @onSpy.called.should.be.true
    @onSpy.firstCall.args[0].should.eql('connection')

  it 'should reply back when receiving connection', ->
    @socket(@mockIO)
    receivedCB = @onSpy.firstCall.args[1]
    receivedCB.should.be.a('function')
    mockSocket =
      emit: sinon.spy()
    receivedCB(mockSocket)
    mockSocket.emit.called.should.be.true
