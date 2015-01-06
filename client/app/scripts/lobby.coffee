ROT = require('./vendor/rot.js/rot')
_ = require('underscore')

Input = require('./ui/input')
Header = require('./ui/header')
List = require('./ui/list')

Game = require('./game')
KeyboardController = require('./keyboard-controller')
gameEvents = require('./game-events')

class Lobby
  constructor: ({@serverUrl}) ->
    @display = new ROT.Display()
    @controller = new KeyboardController()
    $('#game-container').append @display.getContainer()

    @game = new Game(serverUrl: @serverUrl, display: @display)
    @game.start()

  askName: ->
    @display.drawText(1, 1, "Welcome to Sinkohippa!")
    @display.drawText(1, 3, "What is your name? ")
    input = new Input(display: @display, controller: @controller, location: { x: 20, y: 3})
    input.value()

  openLobby: ->
    @display.clear()
    @render()

  render: ->
    @renderHeader()
    @renderGameList()

  renderHeader: ->
    start = @display.getOptions().width / 2
    new Header(display: @display, location: {x: start - 2, y: 1}, text: "LOBBY")
    @display.drawText(1, 4, "Here is a list of ongoing games. Select a game to join, or create a new one:", 45)

  renderGameList: ->
    @fetchGames().done (games) =>
      @gameList = new List(
        display: @display,
        location: {x: 1, y: 7},
        items: _.union ["Create new game"], games
        controller: @controller
      )

      @gameList.value().done (index) =>
        @display.clear()

        if index == 0
          @startGame()
        else
          @joinGame games[index - 1]

  fetchGames: ->
    $.get("#{@serverUrl}/game")

  startGame: ->
    console.log("Start a new game")
    $.post("#{@serverUrl}/game").done (response) =>
      @joinGame(response.gameId)


  joinGame: (id) ->
    console.log("Join game #{id}")
    gameEvents.globalBus.push
      target: 'join-game'
      data:
        url: "#{@serverUrl}/game"
        gameId: id

  destructor: ->
    @gameList?.destructor()

module.exports = Lobby
