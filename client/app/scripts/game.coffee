ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')
_ = require('underscore')
io = require('socket.io-client')

Map = require('./map')
Player = require('./player')
KeyboardController = require('./keyboard-controller')

gameEvents = require('./game-events')

class Game
  init: ->
    @fps = 30
    @players = []

    @display = new ROT.Display()
    @gameContainer = $('#game-container')
    @gameContainer.append @display.getContainer()

    @keyboardController = new KeyboardController()

    @gameSocket = @connectToServer()

    gameEvents.socketMessage(@gameSocket, 'info').onValue (event) -> console.log(event.data)
    gameEvents.socketMessage(@gameSocket, 'map').onValue (event) =>
      @map = new Map(event.data)
      @map?.render(@display)
      console.log "New map set and rendered"
    gameEvents.socketMessage(@gameSocket, 'player-id').onValue (event) =>
      @ownPlayerId = event.data

    gameEvents.socketMessage(@gameSocket, 'state').onValue _.bind(@stateUpdated, @)

    gameEvents.globalBus.filter((ev) -> ev.target == 'server').onValue(_.bind(@sendToServer, @))

  render: ->
    _.forEach @players, (p) => p.render(@display)

  gameLoop: ->
    setTimeout =>
      @requestAnimationFrame(_.bind(@gameLoop, @))
      @render()
    , 1000 / @fps

  start: ->
    console.log "Starting engine"
    @requestAnimationFrame(_.bind(@gameLoop, @))

  connectToServer: ->
    io.connect('http://localhost:5000')

  requestAnimationFrame: (cb) ->
    window.requestAnimationFrame(cb)

  sendToServer: (event) ->
    serverData = event.data
    @gameSocket.emit(serverData.key, serverData.data)

  addNewPlayer: (playerData) ->
    console.log "Adding new player"
    player = new Player(playerData.id, playerData.x, playerData.y)
    if player.id == @ownPlayerId
      player.initButtons()
    @players.push(player)
    player

  stateUpdated: (ev) ->
    updatePlayer = (player, newData) =>
      if !player # new player
        player = @addNewPlayer(newData)

      player.newX = newData.x
      player.newY = newData.y

    # Move players to new positions
    _.forEach ev.data.players, (newData) =>
      player = _.find(@players, (p) -> p.id == newData.id)
      updatePlayer(player, newData)
    
    console.log("state updated")

module.exports = Game
