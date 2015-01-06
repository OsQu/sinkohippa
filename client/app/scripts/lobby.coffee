ROT = require('./vendor/rot.js/rot')
Game = require('./game')
Input = require('./ui/input')
KeyboardController = require('./keyboard-controller')

class Lobby
  constructor: ({@serverUrl}) ->
    @display = new ROT.Display()
    $('#game-container').append @display.getContainer()

  askName: ->
    @display.drawText(0, 0, "Welcome to Sinkohippa!")
    @display.drawText(0, 2, "What is your name? ")
    controller = new KeyboardController()
    input = new Input(display: @display, controller: controller, location: { x: 19, y: 2})
    input.value()

  openLobby: ->
    console.log("Open lobby")

  startGame: -> # TODO: JOIN TOO
    game = new Game(serverUrl: @serverUrl, display: @display)
    game.start()

module.exports = Lobby
