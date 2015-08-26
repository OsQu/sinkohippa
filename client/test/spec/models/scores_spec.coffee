expect = require('chai').expect
Scores = require('../../client/models/scores')

describe 'Scores', ->
  beforeEach ->
    @scores = new Scores()

  it 'is initialized', ->
    expect(@scores).to.be.not.undefined

  it 'sets scores', ->
    @scores.set {player1: 1, player2: 2}
    expect(@scores.forPlayer("player2")).to.be.eql 2

  it 'sets score to player', ->
    @scores.setToPlayer("player1", 2)
    expect(@scores.forPlayer("player1")).to.be.eql 2

