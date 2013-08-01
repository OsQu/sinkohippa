debug = require('debug')('sh:actor-manager')
_ = require('underscore')

Bacon = require('baconjs')

SocketActor = require('./socket-actor')
PlayerActor = require('./player-actor')
MapActor = require('./map-actor')

class ActorManager
  constructor: ->
    @actors = []
    @globalBus = new Bacon.Bus()

    @createMapActor()
    @createSocketActor()

  getMapActor: ->
    _.find(@actors, (a) -> a.type == 'map')

  createMapActor: ->
    debug('Creating map actor')
    mapActor = new MapActor(@)
    @actors.push(mapActor)

  createSocketActor: ->
    debug('Creating socket actor')
    socketActor = new SocketActor(@)
    @actors.push(socketActor)

  createPlayerActor: (playerId) ->
    debug('Creating player actor')
    playerActor = new PlayerActor(@, playerId)
    @actors.push(playerActor)

actorManager = new ActorManager()

module.exports = actorManager
