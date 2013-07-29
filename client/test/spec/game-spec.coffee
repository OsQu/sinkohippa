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

    it 'should add player', ->
      expect(@game.players.length).to.be.equals(0)
      @game.addPlayer(new Player('Test player'))
      expect(@game.players.length).to.be.equals(1)

    it 'should connect to web socket server', ->
      expect(@connectStub.called).to.be.true
