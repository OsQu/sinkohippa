debug = require('debug')('sh:score-actor')
_ = require('underscore')

BaseActor = require('./base-actor')

class ScoreActor extends BaseActor
  constructor: (@manager) ->
    super

    @players = @manager.players()
    @type = 'score'
    @_score = {}

    @bindEvents()

  bindEvents: ->
    @subscribe @manager.globalBus.filter((ev) -> ev.type == 'PLAYER_ADD').onValue (data) => @playerAdded(data.player)
    @subscribe @manager.globalBus.filter((ev) -> ev.type == 'PLAYER_REMOVE').onValue (data) => @playerRemoved(data.player)
    @subscribe @manager.globalBus.filter((ev) -> ev.type == 'PLAYER_DIE').onValue (data) => @playerDied(data.player, data.rocket)

  playerAdded: (player) ->
    unless _.find(@players, (p) -> p == player)
      @players.push(player)
      @_score[player.id] = { name: player.name, score: 0 }

  playerRemoved: (player) ->
    @players = _.reject(@players, (p) -> p == player)
    delete @_score[player.id]

  playerDied: (player, rocket) ->
    shooter = _.find(@players, (p) -> p.id == rocket.shooterId)
    @_updateScore(shooter, 1) if shooter != player

  score: ->
    @_score

  _updateScore: (player, amount) ->
    @_score[player.id].score += amount
    @manager.globalBus.push { type: 'BROADCAST', key: 'score-changed', data: @score() }

  getState: ->
    @score()

module.exports = ScoreActor
