define ['chai-helper', 'sinon', 'rot', 'bacon', 'game'] , (expect, sinon, ROT, Bacon, Game) ->
  'use strict'
  describe 'Game', ->
    beforeEach ->
      @game = new Game

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
