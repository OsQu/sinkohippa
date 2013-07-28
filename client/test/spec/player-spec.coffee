'use strict'
expect = require('chai').expect

Player = require('../scripts/player')
describe 'Player', ->
  beforeEach ->
    @player = new Player

  describe 'After initialization', ->
    it 'should have correct character', ->
      expect(@player.getChar()).to.be.equal '@'

