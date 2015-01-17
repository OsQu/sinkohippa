ROT = require('./vendor/rot.js/rot')
_ = require('underscore')

MessageHandler = require('./message-handler')

Hud = require('./ui/hud')
Map = require('./map')
Player = require('./player')
Rocket = require('./rocket')

gameEvents = require('./game-events')
screenHeight = require('./constants')["screenDimensions"]["height"]

class Game
  constructor: ({@serverUrl, @display}) ->
    @fps = 30
    @players = []
    @items = []

    @messageHandler = new MessageHandler(@)
    @messageHandler.connect()

    @hud = new Hud(display: @display, location: { x: 1, y: screenHeight - 2 })

  render: ->
    for player in @players
      player.render(@display)
    for item in @items
      item.render(@display)

  gameLoop: =>
    setTimeout =>
      @requestAnimationFrame(@gameLoop)
      @render()
    , 1000 / @fps

  start: =>
    console.log "Starting engine"
    @requestAnimationFrame(@gameLoop)

  requestAnimationFrame: (cb) ->
    window.requestAnimationFrame(cb)

  setNewMap: (data) ->
    @map = new Map(data)
    @map.render(@display)
    console.log "New map set and rendered"

  addNewPlayer: (playerData) ->
    if _.some(@players, (existingPlayer) -> existingPlayer.id == playerData.id)
      return

    console.log "Adding new player"
    player = new Player(playerData.id, playerData.color, playerData.x, playerData.y)
    if player.id == @messageHandler.ourId()
      console.log "Found our player!"
      player.initButtons()
      gameEvents.globalBus.push(target: 'hud', data: { health: playerData.health })

    @players.push(player)

  removePlayer: (playerId) ->
    player = _.find @players, (p) -> p.id == playerId
    @players = _.without @players, player
    @map?.renderTile(@display, player.x, player.y)

  playerStateChanged: (newData) ->
    player = _.find(@players, (p) -> p.id == newData.id)
    player.newX = newData.x
    player.newY = newData.y
    player.health = newData.health
    if player.id == @messageHandler.ourId()
      gameEvents.globalBus.push { target: 'hud', data: player }


  addNewRocket: (data) ->
    # TODO: These _.finds could be optimized with a hash table!
    player = _.find @players, (p) -> p.id == data.shooter
    rocket = new Rocket(data.id, data.x, data.y, player, data.direction)
    @items.push(rocket)
    rocket

  removeRocket: (rocketId) ->
    console.log "Destroying rocket"
    item = _.find @items, (i) -> i.id == rocketId
    @items = _.without @items, item
    @map?.renderTile(@display, item.x, item.y)

  moveRocket: (data) ->
    rocket = _.find @items, (i) -> i.id == data.id
    if rocket
      rocket.newX = data.x
      rocket.newY = data.y
    else
      @addNewRocket data

module.exports = Game
