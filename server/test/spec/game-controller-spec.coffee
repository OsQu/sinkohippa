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

  it 'should be able to add a player', ->
    @gameController.players.length.should.eql(0)
    @gameController.addPlayer('id')
    @gameController.players.length.should.eql(1)
