'use strict'
expect = require('chai').expect

ROT = require('../scripts/vendor/rot.js/rot')
Bacon= require('baconjs')
Map = require('../scripts/map')
describe 'Map', ->
  beforeEach ->
    @map = new Map
    @map.generate()

  describe 'After initialization', ->
    it 'should have generated map correctly', ->
      expect(@map.tiles).not.to.be.empty
    it 'should have correct tiles', ->
      tile = @map.tiles[90]
      expect(tile.x).to.be.equal 3
      expect(tile.y).to.be.equal 15
      expect(tile.getChar()).to.be.equal '.'

    it 'should be able to render map', ->
      displaySpy = sinon.spy ROT.Display.prototype, 'draw'
      @map.render(new ROT.Display())
      expect(displaySpy.called).to.be.true
      displaySpy.reset()


