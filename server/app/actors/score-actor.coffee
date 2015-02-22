debug = require('debug')('sh:score-actor')
_ = require('underscore')

class ScoreActor
  constructor: (@manager) ->
    @players = @manager.players()
    @type = 'score'
    @_score = {}

    @bindEvents()

  bindEvents: ->
    @unsubscribePlayerAdd = @manager.globalBus.filter((ev) -> ev.type == 'PLAYER_ADD').onValue (data) => @playerAdded(data.player)
    @unsubscribePlayerRemove = @manager.globalBus.filter((ev) -> ev.type == 'PLAYER_REMOVE').onValue (data) => @playerRemoved(data.player)
    @unsubscribePlayerDie = @manager.globalBus.filter((ev) -> ev.type == 'PLAYER_DIE').onValue (data) => @playerDied(data.player, data.rocket)

  destroy: ->
    @unsubscribePlayerAdd()

  playerAdded: (player) ->
    unless _.find(@players, (p) -> p == player)
      @players.push(player)
      @_score[player.id] = 0

  playerRemoved: (player) ->
    @players = _.reject(@players, (p) -> p == player)
    delete @_score[player.id]

  playerDied: (player, rocket) ->
    shooter = _.find(@players, (p) -> p.id == rocket.shooterId)
    @_updateScore(shooter, 1) if shooter != player

  score: ->
    @_score

  _updateScore: (player, amount) ->
    @_score[player.id] = @_score[player.id] + amount
    @manager.globalBus.push { type: 'BROADCAST', key: 'score-changed', data: @score() }

  getState: ->
    @score()

module.exports = ScoreActor
