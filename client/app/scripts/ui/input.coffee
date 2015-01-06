ROT = require('../vendor/rot.js/rot')
Base = require('./base')

class Input extends Base
  constructor: ({@controller}) ->
    super

    @text = ""
    @returnValue = $.Deferred()
    @input = @controller.onInput().takeUntil(@destruct)

    @returnValue.done => @destructor()

    @bindKeyPresses()
    @render()

  bindKeyPresses: ->
    @input.filter (keyCode) ->
      # Only allow ascii characters
      keyCode >= 32 && keyCode <= 126
    .onValue (keyCode) =>
      char = String.fromCharCode(keyCode)
      @text += char
      @render()

    @input.filter((keyCode) -> keyCode == ROT["VK_BACK_SPACE"]).onValue =>
      @text = @text[0...@text.length - 1]
      @display.draw(@location.x + @text.length + 1, @location.y, " ")
      @render()

    @input.filter((keyCode) -> keyCode == ROT["VK_RETURN"]).onValue =>
      @returnValue.resolve(@text)

  render: ->
    # drawText is NOT suitable for this. It trims text and does all kinds of funny business
    for char, i in @text
      @display.draw(@location.x + i, @location.y, char)
    @display.draw(@text.length + @location.x, @location.y, "█")

  value: ->
    @returnValue.promise()

module.exports = Input
