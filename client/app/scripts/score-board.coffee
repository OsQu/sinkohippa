ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')

KeyboardController = require('./keyboard-controller')
Scores = require('./models/scores')
screenDimensions = require('./constants')["screenDimensions"]

class ScoreBoard
  constructor: (@messageHandler) ->
    @destruct = new Bacon.Bus()
    @scores = new Scores()

    @_bindTabToggle()
    @_listenScoreChanges()

    @display = new ROT.Display(screenDimensions)
    @$element = $(@display.getContainer())
    @$element.attr("id", "score-board")
    $('#game-container').append(@$element)

  toggle: ->
    @$element.toggle()

  destroy: ->
    @destruct.push(true)

  getScores: ->
    @scores

  setScores: (scores) ->
    @scores.set(scores)

  _bindTabToggle: ->
    controller = new KeyboardController()
    controller.bind("TAB", "keydown keyup").takeUntil(@destruct)
    .map (ev) -> ev.type
    .skipDuplicates()
    .onValue (type) =>
      @toggle()

  _listenScoreChanges: ->
    @messageHandler.listenMessages('score-changed').takeUntil(@destruct)
      .onValue (ev) =>
        @setScores(ev.data)

module.exports = ScoreBoard
