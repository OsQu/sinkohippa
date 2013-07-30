should = require('should')
sinon = require('sinon')

describe 'GameController', ->
  beforeEach ->
    @gameController = require('../../app/game-controller')

  it 'should be initialized', ->
    should.exist(@gameController)
    should.exist(@gameController.map)

  it 'should have generated the map', ->
    @gameController.getMap().length.should.be.above(0)
