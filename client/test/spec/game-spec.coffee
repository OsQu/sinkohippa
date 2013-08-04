expect = require('chai').expect

ROT = require('../scripts/vendor/rot.js/rot')
Bacon= require('baconjs')
Game = require('../scripts/game')
Player = require('../scripts/player')
Rocket = require('../scripts/rocket')
io = require('socket.io-client')

'use strict'
describe 'Game', ->
  beforeEach ->
    mockSocket =
      on: ->
      emit: ->
      socket:
        sessionid: 'player-1'
    @connectStub = sinon.stub(io, 'connect', -> mockSocket)
    @requestAnimStub = sinon.stub(Game.prototype, 'requestAnimationFrame')
    @game = new Game()

  afterEach ->
    @connectStub.restore()
    @requestAnimStub.restore()

  describe 'After initialization', ->
    beforeEach ->
      @game.init()

    it 'should have created map correctly', ->
      expect(@game.map).not.to.be.null

    it 'should start polling when calling start', ->
      @game.start()
      expect(@requestAnimStub.called).to.be.true

    it 'should connect to web socket server', ->
      expect(@connectStub.called).to.be.true

    describe 'Got socket event', ->
      it 'should add players from game-state event', ->
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
        @game.gotGameState(state)
        expect(@game.players.length).to.be.equals(1)

      it 'should update map from game-state event', ->
        state =
          data:
            [
              {
                type: 'map'
                state: [{x: 0, y: 0, wall: 1}]
              }
            ]
        @game.gotGameState(state)
        expect(@game.map).to.be.not.undefined

      it 'should update map from map event', ->
        @game.updateMap([{x: 0, y: 0, wall: 1}])
        expect(@game.map).to.be.not.undefined

      it 'should add new player from new-player event', ->
        @game.addNewPlayer
          data:
            id: 'player1'
            x: 1
            y: 1

        expect(@game.players.length).to.be.equals(1)

      it 'should not add player from new-player event if player exists', ->
        @game.players.push(new Player('player', x: 1, y: 1))
        expect(@game.players.length).to.be.equals(1)
        @game.addNewPlayer
          data:
            id: 'player'
            x: 1
            y: 1
        expect(@game.players.length).to.be.equals(1)

      it 'should delete player from player-leaving event', ->
        @game.players.push(new Player('player', x: 1, y: 1))
        expect(@game.players.length).to.be.equals(1)
        @game.playerLeaving
          data: 'player'
        expect(@game.players.length).to.be.equals(0)


      it 'should change player state from player-state-changed event', ->
        @game.players.push(new Player 'player', 100, 100)
        @game.playerStateChanged
          data:
            id: 'player'
            x: 99
            y: 101
        expect(@game.players[0].newX).to.be.equals(99)
        expect(@game.players[0].newY).to.be.equals(101)

      it 'should add rocket as an item when receiving moving events from unknown rocket', ->
        @game.rocketMoved
          data:
            direction: 'down'
            id: 0
            shooter: 'shooter-1'
            x: 2
            y: 5
        expect(@game.items.length).to.be.equals(1)

      it 'should move existing rocket when receiving move event from known rocket', ->
        @game.items.push new Rocket(0, 5, 5, 'shooter-1', 'right')
        @game.rocketMoved
          data:
            direction: 'right'
            id: 0
            shooter: 'shooter-1'
            x: 6
            y: 5
        expect(@game.items.length).to.be.equals(1)
        expect(@game.items[0].newX).to.be.equals(6)
