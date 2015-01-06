expect = require('chai').expect
io = require('socket.io-client')
ROT = require('../client/vendor/rot.js/rot')

Game = require('../client/game')
Player = require('../client/player')
Rocket = require('../client/rocket')
MessageHandler = require('../client/message-handler')
gameEvents = require('../client/game-events')

describe 'MessageHandler', ->
  beforeEach ->
    sinon.stub io, 'connect', ->
      on: ->
      socket: { sessionid: 'ownId' }

    sinon.spy(gameEvents, 'socketMessage')
    @game = new Game(serverUrl: "http://example.com", display: new ROT.Display())

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
      expect(@game.players.length).to.be.equals(1)

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
      expect(@game.map).to.be.not.undefined

    it 'should update map to Game from map event', ->
      @messageHandler.updateMap(data: [{x: 0, y: 0, wall: 1}])
      expect(@game.map.tiles[0]).to.be.not.undefined

    it 'should add new player to Game from new-player event', ->
      @messageHandler.addNewPlayer
        data:
          id: 'player1'
          x: 1
          y: 1
      expect(@game.players.length).to.be.equals(1)

    it 'should delete player to Game from player-leaving event', ->
      player = new Player('player', 0, 0)
      @game.players.push(player)

      @messageHandler.playerLeaving
        data: 'player'

      expect(@game.players.length).to.be.equals(0)

    it 'should change player state to Game from player-state-changed event', ->
      player = new Player('player', 0, 0)
      @game.players.push(player)
      @messageHandler.playerStateChanged
        data:
          id: 'player'
          x: 99
          y: 101
      expect(player.newX).to.be.equals(99)
      expect(player.newY).to.be.equals(101)

    it 'should move rocket in Game from rocket-moving event', ->
      rocket = new Rocket(0, 2, 4, 'shooter-1', 'down')
      @game.items.push(rocket)
      @messageHandler.rocketMoved
        data:
          direction: 'down'
          id: 0
          shooter: 'shooter-1'
          x: 2
          y: 5
      expect(rocket.newY).to.be.equals(5)

    it 'should remove rocket in Game from rocket-destroyed event', ->
      rocket = new Rocket(0, 2, 4, 'shooter-1', 'down')
      @game.items.push(rocket)
      @messageHandler.rocketDestroyed
        data:
          shooter: 'shooter-1'
          id: 0
          x: 5
          y: 5
          direction: 'up'
      expect(@game.items.length).to.be.equals(0)

    it 'should give our id when asking it', ->
      @messageHandler.connect()
      expect(@messageHandler.ourId()).to.be.equals('ownId')
