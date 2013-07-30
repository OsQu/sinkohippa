should = require('should')
sinon = require('sinon')

describe 'GameController', ->
  beforeEach ->
    @gameController = require('../../app/game-controller')
    @gameController.addPlayer('first')

  afterEach ->
    @gameController.players = []

  it 'should be initialized', ->
    should.exist(@gameController)
    should.exist(@gameController.map)

  it 'should have generated the map', ->
    @gameController.getMap().length.should.be.above(0)

  it 'should be able to add a player', ->
    @gameController.players.length.should.eql(1)
    @gameController.addPlayer('second')
    @gameController.players.length.should.eql(2)

  it 'should be able to move player', ->
    player = @gameController.players[0]
    player.x.should.be.eql(0)
    player.y.should.be.eql(0)
    @gameController.movePlayer('first', 'down')
    player.y.should.be.eql(1)
    @gameController.movePlayer('first', 'right')
    player.x.should.be.eql(1)
    @gameController.movePlayer('first', 'up')
    player.y.should.be.eql(0)
    @gameController.movePlayer('first', 'left')
    player.x.should.be.eql(0)
