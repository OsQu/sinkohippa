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

  # Collects state of all actors expect socket and returns it
  getGameState: ->
    gameState = []
    for actor in _.filter(@actors, (a) -> a.type != 'socket')
      gameState.push
        type: actor.type
        state: actor.getState()

    gameState


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

  deletePlayerActor: (playerId) ->
    actor = _.find(@actors, (a) -> a.type == 'player' && a.id == playerId)
    debug("Cleaning player actor #{actor.id}")
    actor.destroy()
    @actors = _.without(@actors, actor)

actorManager = new ActorManager()

module.exports = actorManager
