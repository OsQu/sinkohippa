ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')
_ = require('underscore')

KeyboardController = require('./keyboard-controller')
Scores = require('./models/scores')
Header = require('./ui/header')
List = require('./ui/list')
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
    @render()

  render: ->
    @display.clear()
    @renderHeader()
    @renderScores()

  renderHeader: ->
    start = @display.getOptions().width / 2
    new Header(display: @display, location: {x: start - 2, y: 1}, text: "Scores")

  renderScores: ->
    if @scoreList
      @scoreList.render()
    else
      @scoreList = new List(
        display: @display,
        location: {x: 1, y: 7}
        items: _.bind(@scores.pretty, @scores)
      )

  toggle: ->
    @$element.toggle()

  destroy: ->
    @destruct.push(true)

  getScores: ->
    @scores

  setScores: (scores) ->
    @scores.set(scores)
    @render()

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
