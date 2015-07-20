expect = require('chai').expect

ROT = require('../client/vendor/rot.js/rot')
Bacon= require('baconjs')
Game = require('../client/game')
Player = require('../client/player')
Rocket = require('../client/rocket')

MessageHandler = require('../client/message-handler')
gameEvents = require('../client/game-events')
require("./mocks")["mockGameEvents"]()

'use strict'
describe 'Game', ->
  beforeEach ->
    @requestAnimStub = sinon.stub(Game.prototype, 'requestAnimationFrame')
    @ourId = 'player-1'
    sinon.stub(MessageHandler.prototype, 'connect')
    sinon.stub(MessageHandler.prototype, 'ourId', => @ourId)
    sinon.stub(MessageHandler.prototype, 'listenMessages', => new Bacon.Bus())
    @game = new Game(serverUrl: "http://example.com", display: new ROT.Display())

  afterEach ->
    @requestAnimStub.restore()
    MessageHandler.prototype.connect.restore?()
    MessageHandler.prototype.ourId.restore?()
    MessageHandler.prototype.listenMessages.restore?()

  describe 'After initialization', ->
    it 'should start polling when calling start', ->
      @game.start()
      expect(@requestAnimStub.called).to.be.true

    it 'should save server url', ->
      expect(@game.serverUrl).to.be.equals("http://example.com")

    describe 'Change game state', ->
      it 'should set new map', ->
        @game.setNewMap([{x: 0, y: 0, wall: 1}])
        expect(@game.map).to.be.not.undefined

      it 'should add new player', ->
        @game.addNewPlayer
          id: 'player1'
          x: 1
          y: 1
        expect(@game.players.length).to.be.equals(1)

      it 'should not add player from if player exists', ->
        @game.players.push(new Player('player', x: 1, y: 1))
        expect(@game.players.length).to.be.equals(1)
        @game.addNewPlayer
          id: 'player'
          x: 1
          y: 1
        expect(@game.players.length).to.be.equals(1)

      it 'should remove player', ->
        @game.players.push(new Player('player', x: 1, y: 1))
        expect(@game.players.length).to.be.equals(1)
        @game.removePlayer 'player'
        expect(@game.players.length).to.be.equals(0)


      it 'should change player state', ->
        @game.players.push(new Player 'player', 100, 100)
        @game.playerStateChanged
          id: 'player'
          x: 99
          y: 101
          health: 4
        expect(@game.players[0].newX).to.be.equals(99)
        expect(@game.players[0].newY).to.be.equals(101)
        expect(@game.players[0].health).to.be.equals(4)

      it 'should push hud event if own player state changed', (done) ->
        player = new Player @ourId, 100, 100
        @game.players.push(player)
        gameEvents.globalBus.filter((ev) -> ev.target == 'hud').onValue ->
          done()
        @game.playerStateChanged
          id: @ourId
          x: 99
          y: 101

      it 'should add rocket as an item if moving unknown rocket', ->
        @game.moveRocket
          direction: 'down'
          id: 0
          shooter: 'shooter-1'
          x: 2
          y: 5
        expect(@game.items.length).to.be.equals(1)

      it 'should move existing rocket', ->
        @game.items.push new Rocket(0, 5, 5, 'shooter-1', 'right')
        @game.moveRocket
          direction: 'right'
          id: 0
          shooter: 'shooter-1'
          x: 6
          y: 5
        expect(@game.items.length).to.be.equals(1)
        expect(@game.items[0].newX).to.be.equals(6)

      it 'should remove rocket', ->
        @game.items.push new Rocket(0, 5, 5, 'shooter-1', 'right')
        @game.removeRocket 0
        expect(@game.items.length).to.be.equals(0)
