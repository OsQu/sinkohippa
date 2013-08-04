should = require('should')
sinon = require('sinon')
_ = require('underscore')

actorManager = require('../../app/actors/actor-manager')
MapActor = require('../../app/actors/map-actor')

describe 'MapActor', ->
  beforeEach ->
    @mapActor = new MapActor(actorManager)

  it 'should be correct type', ->
    @mapActor.type.should.be.eql('map')

  it 'should have generated the map', ->
    width = @mapActor.mapWidth
    height = @mapActor.mapHeight
    @mapActor.map.length.should.be.eql(width*height)

  it 'should have transformed arrayed map', ->
    @mapActor.arrayedMap.length.should.be.eql(@mapActor.mapWidth)
    @mapActor.arrayedMap[0].length.should.be.eql(@mapActor.mapHeight)

  it 'should give state', ->
    @mapActor.getState().should.be.an.instanceOf(Array)

  it 'should be able to tell if player can move to point', ->
    @mapActor.canMove(0, 0).should.be.false
    @mapActor.canMove(1, 1).should.be.true
