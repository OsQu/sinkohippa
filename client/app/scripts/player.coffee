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
    @lastMoved = 'up'
  moveDown: ->
    gameEvents.globalBus.push @getMoveEvent('down')
    @lastMoved = 'down'
  moveRight: ->
    gameEvents.globalBus.push @getMoveEvent('right')
    @lastMoved = 'right'
  moveLeft: ->
    gameEvents.globalBus.push @getMoveEvent('left')
    @lastMoved = 'left'

  shootRocket: ->
    gameEvents.globalBus.push
      target: 'server'
      data:
        key: 'player'
        data:
          action: 'shoot'
          direction: @lastMoved

  initButtons: ->
    console.log("Turning on buttons!")
    keyboardController = new KeyboardController()
    keyboardController.bind('h').onValue => @moveLeft()
    keyboardController.bind('j').onValue => @moveDown()
    keyboardController.bind('k').onValue => @moveUp()
    keyboardController.bind('l').onValue => @moveRight()
    keyboardController.bind('space').doAction('.preventDefault').onValue => @shootRocket()

module.exports = Player
