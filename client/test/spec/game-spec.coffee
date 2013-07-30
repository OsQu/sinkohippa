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

    it 'change state of the game correspond to server', ->
      state =
        data:
          players: [
            {
              x: 1
              y: 2
            },
            {
              x: 10,
              y: 20
            }
          ]
      @game.stateUpdated(state)
      expect(@game.playersForRendering[0].x).to.be.equals(1)
      expect(@game.playersForRendering[0].y).to.be.equals(2)
      expect(@game.playersForRendering[1].x).to.be.equals(10)
      expect(@game.playersForRendering[1].y).to.be.equals(20)
