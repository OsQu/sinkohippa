class Score
  constructor: ->
    @scores = {}

  set: (scores) ->
    @scores = scores

  setToPlayer: (player, score) ->
    @scores[player] = score

  forPlayer: (id) ->
    @scores[id]

module.exports = Score
