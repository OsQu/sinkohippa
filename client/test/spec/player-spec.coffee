define ['chai-helper', 'player'] , (expect, Player) ->
  'use strict'
  describe 'Player', ->
    beforeEach ->
      @player = new Player

    describe 'After initialization', ->
      it 'should have correct character', ->
        expect(@player.getChar()).to.be.equal '@'

