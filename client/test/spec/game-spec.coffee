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
    @game = new Game

  afterEach ->
    @connectStub.restore()

  describe 'After initialization', ->
    beforeEach ->
      @pollSpy = sinon.spy Bacon, 'fromPoll'
      @game.init()

    afterEach ->
      @pollSpy.restore()

    it 'should have created map correctly', ->
      expect(@game.map).not.to.be.null

    it 'should have game loop ready', ->
      expect(@pollSpy.called).to.be.true

    it 'should start polling when calling start', ->
      expect(@game.gameLoopStream).to.be.undefined
      @game.start()
      expect(@game.gameLoopStream).to.be.not.undefined

    it 'should add player', ->
      expect(@game.players.length).to.be.equals(0)
      @game.addPlayer(new Player('Test player'))
      expect(@game.players.length).to.be.equals(1)

    it 'should connect to web socket server', ->
      expect(@connectStub.called).to.be.true
