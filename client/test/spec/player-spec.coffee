'use strict'
expect = require('chai').expect

Player = require('../scripts/player')
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

