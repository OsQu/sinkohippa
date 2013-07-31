KeyboardController = require('./keyboard-controller')

gameEvents = require('./game-events')

class Player
  constructor: (@id, @x, @y) ->

  getChar: ->
    '@'

  render: (display) ->
    @handleNewPosition(display)
    display.draw(@x, @y, @getChar())

  clearCurrentPosition: (display) ->
    # Assume that player can't stand inside the wall. This might need improving
    display.draw(@x, @y, '.')

  handleNewPosition: (display) ->
    if @newX or @newY
      @clearCurrentPosition(display)
      @x = @newX
      @y = @newY
      delete @newX
      delete @newY

  getMoveEvent: (direction) ->
    target: 'server'
    data:
      key: 'player'
      data:
        action: 'move'
        direction: direction

  moveUp: ->
    gameEvents.globalBus.push @getMoveEvent('up')
  moveDown: ->
    gameEvents.globalBus.push @getMoveEvent('down')
  moveRight: ->
    gameEvents.globalBus.push @getMoveEvent('right')
  moveLeft: ->
    gameEvents.globalBus.push @getMoveEvent('left')

  shootRocket: ->
    console.log("shoot rocket!")

  initButtons: ->
    console.log("Turning on buttons!")
    keyboardController = new KeyboardController()
    keyboardController.bind('h').onValue => @moveLeft()
    keyboardController.bind('j').onValue => @moveDown()
    keyboardController.bind('k').onValue => @moveUp()
    keyboardController.bind('l').onValue => @moveRight()
    keyboardController.bind('space').onValue => @shootRocket()

module.exports = Player
