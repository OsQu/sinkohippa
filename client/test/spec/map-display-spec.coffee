expect = require('chai').expect
sinon = require('sinon')

MapDisplay = require('../client/map-display')

describe 'MapDisplay', ->
  beforeEach ->
    @displayStub =
      draw: sinon.stub()

    @mapDisplay = new MapDisplay(@displayStub, width: 20, height: 20)

  it 'allows calls inside the region', ->
    @mapDisplay.draw(2, 2, "foobar")
    expect(@displayStub.draw.withArgs(2, 2, "foobar").calledOnce).to.be.true

  it 'does not allow calls outside the region', ->
    @mapDisplay.draw(2, 22, "foobar")
    expect(@displayStub.draw.withArgs(2, 22, "foobar").calledOnce).to.be.false
