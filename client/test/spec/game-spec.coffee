define ['chai-helper', 'sinon', 'rot', 'game'] , (expect, sinon, ROT, Game) ->
  'use strict'
  describe 'Game', ->
    beforeEach ->
      @game = new Game
      @game.init()
    describe 'After initialization', ->
      it 'should have created map correctly', ->
        expect(@game.map).not.to.be.empty
      it "should be able to render map using ROT's draw function", ->
        displaySpy = sinon.spy ROT.Display.prototype, 'draw'
        @game.render()
        expect(displaySpy.called).to.be.true
