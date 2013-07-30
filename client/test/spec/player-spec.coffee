'use strict'
expect = require('chai').expect

Player = require('../scripts/player')
gameEvents = require('../scripts/game-events')
describe 'Player', ->
  beforeEach ->
    @player = new Player

  describe 'After initialization', ->
    it 'should have correct character', ->
      expect(@player.getChar()).to.be.equal '@'
    it 'should render player correctly', (done) ->
      mockDisplay =
        draw: (x, y, char) ->
          expect(char).to.be.equals('@')
          done()
      @player.render(mockDisplay)

    it 'should be able to move around', ->
      expectCoords = (player, x, y) ->
        expect(player.x).to.be.equals(x)
        expect(player.y).to.be.equals(y)
      expectCoords(@player, 0, 0)
      @player.moveRight()
      expectCoords(@player, 1, 0)
      @player.moveDown()
      expectCoords(@player, 1, 1)
      @player.moveUp()
      expectCoords(@player, 1, 0)
      @player.moveLeft()
      expectCoords(@player, 0, 0)

    it 'should bind hjkl for moving', ->
      KeyboardController = require('../scripts/keyboard-controller')
      bindStub = sinon.stub KeyboardController.prototype, 'bind', ->
        onValue: ->

      stubbedPlayer = new Player('stubbed')
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

