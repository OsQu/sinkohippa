define ['chai-helper', 'sinon', 'rot', 'game'] , (expect, sinon, ROT, Game) ->
  'use strict'
  describe 'Game', ->
    beforeEach ->
      @game = new Game
      @game.init()
    describe 'After initialization', ->
      it 'should have created map correctly', ->
        expect(@game.map).not.to.be.null
