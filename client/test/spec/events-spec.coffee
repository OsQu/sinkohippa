'use strict'

expect = require('chai').expect

describe 'Socket Events', ->
  beforeEach ->
    @gameEvents = require('../scripts/game-events')

  it 'should push socket messages to bus', (done) ->
    onSpy = sinon.spy()
    mockSocket =
      on: onSpy
    @gameEvents.socketMessage(mockSocket, 'test').onValue (event) ->
      expect(event.data).to.be.equals('test-data')
      expect(event.key).to.be.equals('test')
      done()

    expect(onSpy.called).to.be.true
    onCB = onSpy.firstCall.args[1]
    onCB('test-data')

  it 'should have global bus', ->
    expect(@gameEvents.globalBus).to.be.defined
