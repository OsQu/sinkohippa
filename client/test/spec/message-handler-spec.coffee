expect = require('chai').expect
io = require('socket.io-client')

MessageHandler = require('../scripts/message-handler')
gameEvents = require('../scripts/game-events')

describe 'MessageHandler', ->
  beforeEach ->
    sinon.stub io, 'connect', ->
      on: ->
      socket: { sessionid: 'ownId' }

    sinon.spy(gameEvents, 'socketMessage')
    @game =
      setNewMap: sinon.spy()
      addNewPlayer: sinon.spy()
      removePlayer: sinon.spy()
      playerStateChanged: sinon.spy()
      addNewRocket: sinon.spy()
      removeRocket: sinon.spy()
      moveRocket: sinon.spy()

    @messageHandler = new MessageHandler @game

  afterEach ->
    io.connect.restore?()
    gameEvents.socketMessage.restore?()

  it 'should connect to server', ->
    @messageHandler.connect()
    expect(@messageHandler.gameSocket).to.be.not.undefined
    expect(io.connect.called).to.be.true

  it 'should bind socket events', ->
    @messageHandler.connect()
    expect(gameEvents.socketMessage.called).to.be.true

  describe 'Got socket event', ->
    it 'should add new player to Game when got game state', ->
      state =
        data:
          [
            {
              type: 'player'
              state:
                id: 'player-1'
                x: '5'
                y: '6'
            }
          ]
      @messageHandler.gotGameState(state)
      expect(@game.addNewPlayer.called).to.be.true

    it 'should update map to Game from game state event', ->
      state =
        data:
          [
            {
              type: 'map'
              state: [{x: 0, y: 0, wall: 1}]
            }
          ]
      @messageHandler.gotGameState(state)
      expect(@game.setNewMap.called).to.be.true

    it 'should update map to Game from map event', ->
      @messageHandler.updateMap([{x: 0, y: 0, wall: 1}])
      expect(@game.setNewMap.called).to.be.true

    it 'should add new player to Game from new-player event', ->
      @messageHandler.addNewPlayer
        data:
          id: 'player1'
          x: 1
          y: 1
      expect(@game.addNewPlayer.called).to.be.true

    it 'should delete player to Game from player-leaving event', ->
      @messageHandler.playerLeaving
        data: 'player'

      expect(@game.removePlayer.called).to.be.true

    it 'should change player state to Game from player-state-changed event', ->
      @messageHandler.playerStateChanged
        data:
          id: 'player'
          x: 99
          y: 101
      expect(@game.playerStateChanged.called).to.be.true

    it 'should move rocket in Game from rocket-moving event', ->
      @messageHandler.rocketMoved
        data:
          direction: 'down'
          id: 0
          shooter: 'shooter-1'
          x: 2
          y: 5
      expect(@game.moveRocket.called).to.be.true

    it 'should remove rocket in Game from rocket-destroyed event', ->
      @messageHandler.rocketDestroyed
        data:
          shooter: 'shooter-1'
          id: 0
          x: 5
          y: 5
          direction: 'up'
      expect(@game.removeRocket.called).to.be.true

    it 'should give our id when asking it', ->
      @messageHandler.connect()
      expect(@messageHandler.ourId()).to.be.equals('ownId')
