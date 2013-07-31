ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')

class KeyboardController
  bind: (key) ->
    rotKeyCode = "VK_#{key.toUpperCase()}"
    code = ROT[rotKeyCode]
    $('html').asEventStream('keydown').doAction('.preventDefault').filter((ev) ->
      ev.keyCode == code)

module.exports = KeyboardController
