'use strict'

expect = require('chai').expect

describe 'Socket Events', ->
  beforeEach ->
    @eventHandler = require('../scripts/game-events')

  it 'should push event to bus when', (done) ->
    onSpy = sinon.spy()
    mockSocket =
      on: onSpy
    @eventHandler.on(mockSocket, 'test').onValue (event) ->
      expect(event.data).to.be.equals('test-data')
      expect(event.key).to.be.equals('test')
      done()

    expect(onSpy.called).to.be.true
    onCB = onSpy.firstCall.args[1]
    onCB('test-data')
