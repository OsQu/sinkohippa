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
    @lastMoved = 'up'
  moveDown: ->
    gameEvents.globalBus.push @getMoveEvent('down')
    @lastMoved = 'down'
  moveRight: ->
    gameEvents.globalBus.push @getMoveEvent('right')
    @lastMoved = 'right'
  moveLeft: ->
    console.log "moving left"
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
    keyboardController.bind('h').merge(keyboardController.bind("left")).onValue => @moveLeft()
    keyboardController.bind('j').merge(keyboardController.bind("down")).onValue => @moveDown()
    keyboardController.bind('k').merge(keyboardController.bind("up")).onValue => @moveUp()
    keyboardController.bind('l').merge(keyboardController.bind("right")).onValue => @moveRight()
    keyboardController.bind('space').doAction('.preventDefault').onValue => @shootRocket()

module.exports = Player
