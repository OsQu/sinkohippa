ROT = require('./vendor/rot.js/rot')
Bacon = require('baconjs')
_ = require('underscore')
io = require('socket.io-client')

Map = require('./map')
Player = require('./player')
Rocket = require('./rocket')
KeyboardController = require('./keyboard-controller')

gameEvents = require('./game-events')

class Game
  init: ->
    @fps = 30
    @players = []
    @items = []

    @display = new ROT.Display()
    @gameContainer = $('#game-container')
    @gameContainer.append @display.getContainer()

    @keyboardController = new KeyboardController()

    @gameSocket = @connectToServer()
    @bindEvents()

  bindEvents: ->
    gameEvents.socketMessage(@gameSocket, 'game-state').onValue @gotGameState
    gameEvents.socketMessage(@gameSocket, 'map').onValue @updateMap
    gameEvents.socketMessage(@gameSocket, 'info').onValue @gotServerInfo
    gameEvents.socketMessage(@gameSocket, 'new-player').onValue @addNewPlayer
    gameEvents.socketMessage(@gameSocket, 'player-leaving').onValue @playerLeaving
    gameEvents.socketMessage(@gameSocket, 'player-state-changed').onValue @playerStateChanged
    gameEvents.socketMessage(@gameSocket, 'rocket-moved').onValue @rocketMoved
    gameEvents.socketMessage(@gameSocket, 'rocket-destroyed').onValue @rocketDestroyed

    gameEvents.globalBus.filter((ev) -> ev.target == 'server').onValue @sendToServer

  gotGameState: (event) =>
    state = event.data
    for part in state
      switch part.type
        when 'map' then @updateMap { data: part.state }
        when 'player' then @addNewPlayer { data: part.state }

  updateMap: (event) =>
    @map = new Map(event.data)
    @renderMap()
    console.log "New map set and rendered"

  gotServerInfo: (event) =>
    console.log event.data

  addNewPlayer: (ev) =>
    playerData = ev.data

    if _.some(@players, (existingPlayer) -> existingPlayer.id == playerData.id)
      return

    console.log "Adding new player"
    player = new Player(playerData.id, playerData.x, playerData.y)
    if player.id == @gameSocket.socket.sessionid
      console.log "Found our player!"
      player.initButtons()

    @players.push(player)

  playerLeaving: (ev) =>
    console.log "Removing player"
    playerId = ev.data
    @players = _.filter @players, (p) -> p.id != playerId
    @renderMap()

  playerStateChanged: (ev) =>
    newData = ev.data
    player = _.find(@players, (p) -> p.id == newData.id)
    player.newX = newData.x
    player.newY = newData.y

  addNewRocket: (data) ->
    rocket = new Rocket(data.id, data.x, data.y, data.shooter, data.direction)
    @items.push(rocket)
    rocket

  rocketMoved: (ev) =>
    data = ev.data
    rocket = _.find @items, (i) -> i.id == data.id
    if rocket
      rocket.newX = data.x
      rocket.newY = data.y
    else
      @addNewRocket data

  rocketDestroyed: (ev) =>
    console.log "Destroying rocket"

  sendToServer: (event) =>
    serverData = event.data
    @gameSocket.emit(serverData.key, serverData.data)

  render: ->
    _.forEach @players, (p) => p.render(@display)
    _.forEach @items, (i) => i.render(@display)

  renderMap: ->
    @map?.render(@display)

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

module.exports = Game
