'use strict'

expect = require('chai').expect

describe 'Socket Events', ->
  beforeEach ->
    @eventHandler = require('../scripts/events')

  it 'should listen info events', ->
    onSpy = sinon.spy()
    mockSocket =
      on: onSpy
    @eventHandler.handleEvents(mockSocket)
    expect(onSpy.called).to.be.true
    expect(onSpy.firstCall.args[0]).to.be.equals('info')
