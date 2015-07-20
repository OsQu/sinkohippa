ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')

class KeyboardController
  BINDING_SELECTOR = 'html'
  onInput: ->
    $(BINDING_SELECTOR)
      .asEventStream('keydown')
      .doAction(".preventDefault")
      .map(".which")

  bind: (key, event = 'keydown') ->
    rotKeyCode = "VK_#{key.toUpperCase()}"
    code = ROT[rotKeyCode]
    $(BINDING_SELECTOR).asEventStream(event).filter((ev) ->
      ev.keyCode == code)
    .doAction(".preventDefault")

module.exports = KeyboardController
