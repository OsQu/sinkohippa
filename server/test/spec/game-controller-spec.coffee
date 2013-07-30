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

  it 'should be able to remove a player', ->
    @gameController.players.length.should.eql(1)
    @gameController.removePlayer('first')
    @gameController.players.length.should.eql(0)


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

  it 'should give game state', ->
    @gameController.addPlayer('second')
    @gameController.players[0].x = 5
    @gameController.players[0].y = 3
    @gameController.players[1].x = 8
    @gameController.players[1].y = 7
    state = @gameController.getGameState()
    state.players[0].x.should.eql(5)
    state.players[0].y.should.eql(3)
    state.players[1].x.should.eql(8)
    state.players[1].y.should.eql(7)
    state.map.length.should.be.above(0)

