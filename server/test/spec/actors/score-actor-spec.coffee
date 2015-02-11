should = require('should')
sinon = require('sinon')
_ = require('underscore')
Bacon = require('baconjs')

GameManager = require('../../../app/actors/game-manager')
ScoreActor = require('../../../app/actors/score-actor')
PlayerActor = require('../../../app/actors/player-actor')
Factory = require('../factory')

describe 'ScoreActor', ->
  beforeEach ->
    @gameManager = new GameManager(0)
    @oldBus = @gameManager.globalBus
    @gameManager.globalBus = new Bacon.Bus()

    @scoreActor = new ScoreActor(@gameManager)

  afterEach ->
    @gameManager.globalBus = @oldBus

  it 'adds player when it\'s created', ->
    playerCount = @scoreActor.players.length
    Factory.playerActor(gameManager: @gameManager)
    @scoreActor.players.length.should.be.eql(playerCount + 1)

  it 'removes player when it\'s destroyed', ->
    player = new PlayerActor(@gameManager, '123')
    playerCount = @scoreActor.players.length
    player.destroy()
    @scoreActor.players.length.should.be.eql(playerCount - 1)

  describe 'with two players', ->
    beforeEach ->
      @clock = sinon.useFakeTimers(0)
      @player1 = Factory.playerActor(gameManager: @gameManager, id: '1', health: 1)
      @player2 = Factory.playerActor(gameManager: @gameManager, id: '2', health: 1, x: 2)

    afterEach ->
      @clock.restore()

    it 'increases score if player kills another player', ->
      @player1.shootWithPlayer({ direction: 'right' })
      @clock.tick(100)
      @scoreActor.score()[@player1.id].should.be.eql(1)

    it 'broadcasts score-changed when scores are updated', (done) ->
      @gameManager.globalBus.filter((ev) -> ev.type == 'BROADCAST' && ev.key == 'score-changed').onValue -> done()
      @player1.shootWithPlayer({ direction: 'right' })
      @clock.tick(100)

