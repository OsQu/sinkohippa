KeyboardController = require('./keyboard-controller')

gameEvents = require('./game-events')

class Player
  constructor: (@id, @color, @x, @y) ->

  getChar: ->
    '@'

  render: (display) ->
    @handleNewPosition(display)
    display.draw(@x, @y, @getChar(), @colorCode())

  colorCode: ->
    switch @color
      when "red" then "#ff0000"
      when "blue" then "#1b6cde"
      when "green" then "#00ff00"
      when "white" then "#ffffff"
      when "yellow" then "#ffff00"
      else "#ffffff"

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

  shootRocket: (direction) ->
    gameEvents.globalBus.push
      target: 'server'
      data:
        key: 'player'
        data:
          action: 'shoot'
          direction: direction

  initButtons: ->
    console.log("Turning on buttons!")
    keyboardController = new KeyboardController()
    keyboardController.bind('h').merge(keyboardController.bind("left")).onValue => @moveLeft()
    keyboardController.bind('j').merge(keyboardController.bind("down")).onValue => @moveDown()
    keyboardController.bind('k').merge(keyboardController.bind("up")).onValue => @moveUp()
    keyboardController.bind('l').merge(keyboardController.bind("right")).onValue => @moveRight()

    keyboardController.bind('w').doAction('.preventDefault').onValue => @shootRocket("up")
    keyboardController.bind('d').doAction('.preventDefault').onValue => @shootRocket("right")
    keyboardController.bind('s').doAction('.preventDefault').onValue => @shootRocket("down")
    keyboardController.bind('a').doAction('.preventDefault').onValue => @shootRocket("left")

module.exports = Player
