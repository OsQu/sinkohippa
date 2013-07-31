expect = require('chai').expect

ROT = require('../scripts/vendor/rot.js/rot')
Bacon= require('baconjs')
Game = require('../scripts/game')
Player = require('../scripts/player')
io = require('socket.io-client')
'use strict'
describe 'Game', ->
  beforeEach ->
    mockSocket =
      on: ->
      emit: ->
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

    describe 'Got new state', ->
      beforeEach ->
        @state =
          data:
            players: [
              {
                id: 'player'
                x: 1
                y: 2
              },
            ]

      it 'should add new players to map when noticing them in new state', ->
        @game.stateUpdated(@state)
        expect(@game.players[0].id).to.be.equals('player')
        expect(@game.players[0].x).to.be.equals(1)
        expect(@game.players[0].y).to.be.equals(2)

      it 'should add new state of existing player according to new state', ->
        @game.players.push(new Player 'player', 100, 100)
        @game.stateUpdated(@state)
        expect(@game.players[0].id).to.be.equals('player')
        expect(@game.players[0].newX).to.be.equals(1)
        expect(@game.players[0].newY).to.be.equals(2)
