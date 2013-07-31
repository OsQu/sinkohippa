'use strict'
expect = require('chai').expect

Player = require('../scripts/player')
gameEvents = require('../scripts/game-events')
describe 'Player', ->
  beforeEach ->
    @player = new Player '', 0, 0

  describe 'After initialization', ->
    it 'should have correct character', ->
      expect(@player.getChar()).to.be.equal '@'
    it 'should render player correctly', (done) ->
      mockDisplay =
        draw: (x, y, char) ->
          expect(char).to.be.equals('@')
          done()
      @player.render(mockDisplay)

    it 'should move player to new position if possible', ->
      @player.newX = 5
      @player.newY = 6
      @player.handleNewPosition({ draw: -> })
      expect(@player.x).to.be.equal(5)
      expect(@player.y).to.be.equal(6)

    it 'should clear current position if new position exists', ->
      @player.newX = 5
      drawSpy = sinon.spy()
      @player.handleNewPosition({ draw: drawSpy })
      expect(drawSpy.called).to.be.true
      expect(drawSpy.firstCall.args[0]).to.be.equals(0)
      expect(drawSpy.firstCall.args[2]).to.be.equals('.')

    it 'should bind hjkl for moving', ->
      KeyboardController = require('../scripts/keyboard-controller')
      bindStub = sinon.stub KeyboardController.prototype, 'bind', ->
        onValue: ->

      stubbedPlayer = new Player('stubbed')
      stubbedPlayer.initButtons()
      expect(bindStub.callCount).to.be.equals(4)
      expect(bindStub.firstCall.args[0]).to.be.equal('h')
      expect(bindStub.secondCall.args[0]).to.be.equal('j')
      expect(bindStub.getCall(2).args[0]).to.be.equal('k')
      expect(bindStub.getCall(3).args[0]).to.be.equal('l')

      bindStub.restore()

    it 'should send moving data to server', (done) ->
      count = 0
      gameEvents.globalBus.onValue (ev) ->
        count++
        expect(ev.target).to.be.equals('server')
        if count >= 3
          done()

      @player.moveUp()
      @player.moveDown()
      @player.moveRight()
      @player.moveLeft()

