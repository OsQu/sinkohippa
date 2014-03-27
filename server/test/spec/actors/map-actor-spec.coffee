should = require('should')
sinon = require('sinon')
_ = require('underscore')

GameManager = require('../../../app/actors/game-manager')
MapActor = require('../../../app/actors/map-actor')

describe 'MapActor', ->
  beforeEach ->
    @gameManager = new GameManager(0)
    @mapActor = new MapActor(@gameManager)

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

  it 'should destroy rocket when it hits the wall', ->
    sinon.spy(@gameManager, 'deleteRocketActor')
    @gameManager.globalBus.push { type: 'ROCKET_MOVED', x: 0, y: 0, rocketId: 0 }
    @gameManager.deleteRocketActor.called.should.be.true
    @gameManager.deleteRocketActor.restore?()
