KeyboardController = require('./keyboard-controller')

class Player
  constructor: (@name) ->
    keyboardController = new KeyboardController()
    keyboardController.bind('h').onValue => @moveLeft()
    keyboardController.bind('j').onValue => @moveDown()
    keyboardController.bind('k').onValue => @moveUp()
    keyboardController.bind('l').onValue => @moveRight()
    @x = 0
    @y = 0

  getChar: ->
    '@'

  render: (display) ->
    display.draw(@x, @y, @getChar())

  moveUp: -> @y--
  moveDown: -> @y++
  moveRight: -> @x++
  moveLeft: -> @x--


module.exports = Player
