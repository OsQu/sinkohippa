'use strict'
expect = require('chai').expect

ROT = require('../client/vendor/rot.js/rot')
Bacon = require('baconjs')
_ = require('underscore')
Map = require('../client/map')
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
      displaySpy.restore()

    it 'should be able to render specific tile', ->
      displaySpy = sinon.spy ROT.Display.prototype, 'draw'
      tile = _.find @map.tiles, (t) -> t.x == 4 && t.y == 5
      @map.renderTile(new ROT.Display(), 4, 5)
      expect(displaySpy.called).to.be.true
      args = displaySpy.firstCall.args
      expect(args[0]).to.be.equals(4)
      expect(args[1]).to.be.equals(5)
      expect(args[2]).to.be.equals(tile.getChar())

      displaySpy.restore()

