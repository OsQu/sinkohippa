ROT = require('./vendor/rot.js/rot')
_ = require('underscore')

Input = require('./ui/input')
Header = require('./ui/header')
SelectableList = require('./ui/selectable_list')

Game = require('./game')
KeyboardController = require('./keyboard-controller')
gameEvents = require('./game-events')
screenDimensions = require('./constants')["screenDimensions"]

class Lobby
  constructor: ({@serverUrl}) ->
    @display = new ROT.Display(screenDimensions)
    @controller = new KeyboardController()
    $('#game-container').append @display.getContainer()

    @game = new Game(serverUrl: @serverUrl, display: @display)
    @game.start()

  askName: ->
    @display.drawText(1, 1, "Welcome to Sinkohippa!")
    @display.drawText(1, 3, "Move with arrow keys or [hjkl]. Shoot with [wasd]. Happy shooting!")
    @display.drawText(1, 5, "What is your name? ")
    input = new Input(display: @display, controller: @controller, location: { x: 20, y: 5})
    input.value()

  openLobby: ->
    @display.clear()
    @askName().done (name) =>
      if name != ""
        @playerName = name
        @display.clear()
        @render()
      else
        alert("Excuse me miss/sir, the name cannot be empty.")
        @openLobby()

  render: ->
    @renderHeader()
    @renderGameList()

  renderHeader: ->
    start = @display.getOptions().width / 2
    new Header(display: @display, location: {x: start - 2, y: 1}, text: "LOBBY")
    @display.drawText(1, 4, "Here is a list of ongoing games. Select a game to join, or create a new one:", 45)

  renderGameList: ->
    @fetchGames().done (games) =>
      @gameList = new SelectableList(
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
    $.post("#{@serverUrl}/game").done (response) =>
      @joinGame(response.gameId)


  joinGame: (id) ->
    console.log("Join game #{id}")
    gameEvents.globalBus.push
      target: 'join-game'
      data:
        url: "#{@serverUrl}/game"
        gameId: id
        playerName: @playerName

  destructor: ->
    @gameList?.destructor()

module.exports = Lobby
