expect = require('chai').expect
Score = require('../../client/models/score')

describe 'Score', ->
  beforeEach ->
    @score = new Score()

  it 'is initialized', ->
    expect(@score).to.be.not.undefined

  it 'sets scores', ->
    @score.set {player1: 1, player2: 2}
    expect(@score.forPlayer("player2")).to.be.eql 2

  it 'sets score to player', ->
    @score.setToPlayer("player1", 2)
    expect(@score.forPlayer("player1")).to.be.eql 2

