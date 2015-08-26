_ = require('underscore')

class Scores
  constructor: ->
    @scores = {}

  set: (scores) ->
    @scores = scores

  setToPlayer: (player, score) ->
    @scores[player] = score

  forPlayer: (id) ->
    @scores[id]

  pretty: ->
    _.map(@scores, (score) -> "#{score.name}: #{score.score}")

module.exports = Scores
