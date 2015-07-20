ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')

KeyboardController = require('./keyboard-controller')
screenDimensions = require('./constants')["screenDimensions"]

class ScoreBoard
  constructor: ->
    @destruct = new Bacon.Bus()

    @_bindTabToggle()

    @display = new ROT.Display(screenDimensions)
    @$element = $(@display.getContainer())
    @$element.attr("id", "score-board")
    $('#game-container').append(@$element)

  toggle: ->
    @$element.toggle()

  destroy: ->
    @destruct.push(true)

  _bindTabToggle: ->
    controller = new KeyboardController()
    controller.bind("TAB", "keydown keyup").takeUntil(@destruct)
    .map (ev) -> ev.type
    .skipDuplicates()
    .onValue (type) =>
      @toggle()

module.exports = ScoreBoard
