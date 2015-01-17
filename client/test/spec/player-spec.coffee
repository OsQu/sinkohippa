'use strict'
expect = require('chai').expect
Bacon = require('baconjs')

Player = require('../client/player')
gameEvents = require('../client/game-events')

describe 'Player', ->
  beforeEach ->
    @player = new Player '', "white", 0, 0

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

    it 'should track the last movement', ->
      @player.moveUp()
      expect(@player.lastMoved).to.be.equals('up')
      @player.moveDown()
      expect(@player.lastMoved).to.be.equals('down')
      @player.moveLeft()
      expect(@player.lastMoved).to.be.equals('left')
      @player.moveRight()
      expect(@player.lastMoved).to.be.equals('right')

    it 'should send shooting data to server', (done) ->
      unsubGlobalBus = gameEvents.globalBus.onValue (ev) ->
        expect(ev.target).to.be.equals('server')
        expect(ev.data.key).to.be.equals('player')
        expect(ev.data.data.action).to.be.equals('shoot')
        expect(ev.data.data.direction).to.be.equals('up')
        unsubGlobalBus()
        done()

      @player.lastMoved = 'up'
      @player.shootRocket()

    describe 'keyboard bindings', ->
      beforeEach ->
        @stubbedPlayer = new Player('stubbed')
        @stubbedPlayer.initButtons()

      afterEach ->
        @unsubKeydown()

      it 'should bind h to move left', (done) ->
        @unsubKeydown = $('html').asEventStream('keydown').onValue =>
          expect(@stubbedPlayer.lastMoved).to.be.equals('left')
          done()
        hEvent = $.Event('keydown')
        hEvent.keyCode = 72
        $('html').trigger(hEvent)

      it 'should bind left to move left', (done) ->
        @unsubKeydown = $('html').asEventStream('keydown').onValue =>
          expect(@stubbedPlayer.lastMoved).to.be.equals('left')
          done()
        leftEvent = $.Event('keydown')
        leftEvent.keyCode = 37
        $('html').trigger(leftEvent)

      it 'should bind j to move down', (done) ->
        @unsubKeydown = $('html').asEventStream('keydown').onValue =>
          expect(@stubbedPlayer.lastMoved).to.be.equals('down')
          done()
        jEvent = $.Event('keydown')
        jEvent.keyCode = 74
        $('html').trigger(jEvent)

      it 'should bind down to move down', (done) ->
        @unsubKeydown = $('html').asEventStream('keydown').onValue =>
          expect(@stubbedPlayer.lastMoved).to.be.equals('down')
          done()
        downEvent = $.Event('keydown')
        downEvent.keyCode = 40
        $('html').trigger(downEvent)

      it 'should bind k to move up', (done) ->
        @unsubKeydown = $('html').asEventStream('keydown').onValue =>
          expect(@stubbedPlayer.lastMoved = 'up')
          done()
        kEvent = $.Event('keydown')
        kEvent.keyCode = 75
        $('html').trigger(kEvent)

      it 'should bind up to move down', (done) ->
        @unsubKeydown = $('html').asEventStream('keydown').onValue =>
          expect(@stubbedPlayer.lastMoved = 'up')
          done()
        upEvent = $.Event('keydown')
        upEvent.keyCode = 38
        $('html').trigger(upEvent)

      it 'should bind l move right', (done) ->
        @unsubKeydown = $('html').asEventStream('keydown').onValue =>
          expect(@stubbedPlayer.lastMoved = 'right')
          done()
        lEvent = $.Event('keydown')
        lEvent.keyCode = 76
        $('html').trigger(lEvent)

      it 'should bind right to move right', (done) ->
        @unsubKeydown = $('html').asEventStream('keydown').onValue =>
          expect(@stubbedPlayer.lastMoved = 'right')
          done()
        rightEvent = $.Event('keydown')
        rightEvent.keyCode = 39
        $('html').trigger(rightEvent)
