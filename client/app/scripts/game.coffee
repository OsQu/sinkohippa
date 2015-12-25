ROT = require('./vendor/rot.js/rot')
_ = require('underscore')

MessageHandler = require('./message-handler')

Hud = require('./ui/hud')
ScoreBoard = require('./score-board')
Map = require('./map')
Player = require('./player')
Rocket = require('./rocket')
Corpse = require('./corpse')
Explosion = require('./explosion')
MapDisplay = require('./map-display')

gameEvents = require('./game-events')
screenDimensions = require('./constants')['screenDimensions']
mapDimensions = require('./constants')['mapDimensions']

class Game
  constructor: ({@serverUrl, @display}) ->
    @fps = 30
    @players = []
    @items = []
    @corpses = []
    @explosions = []
    @resetTiles = []

    @messageHandler = new MessageHandler(@)
    @messageHandler.connect()

    @hud = new Hud(display: @display, location: { x: 1, y: screenDimensions.height - 2 })
    @mapDisplay = new MapDisplay(@display, mapDimensions)
    @scoreBoard = new ScoreBoard(@messageHandler)

  render: ->
    for [x, y] in @resetTiles
      @map?.renderTile(@mapDisplay, x, y)
      @resetTiles = []
    for corpse in @corpses
      corpse.render(@mapDisplay)
    for player in @players
      player.render(@mapDisplay)
    for item in @items
      item.render(@mapDisplay)
    for explosion in @explosions
      explosion.render(@mapDisplay)

  gameLoop: =>
    setTimeout @gameLoop, 1000 / @fps
    @requestAnimationFrame(=> @render())

  start: =>
    console.log "Starting engine"
    @requestAnimationFrame(@gameLoop)

  requestAnimationFrame: (cb) ->
    window.requestAnimationFrame(cb)

  setNewMap: (data) ->
    @map = new Map(data)
    @map.render(@mapDisplay)
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
    @resetTiles = @resetTiles.concat(player.tilesToReset())

  playerStateChanged: (newData) ->
    player = _.find(@players, (p) -> p.id == newData.id)
    @resetTiles = @resetTiles.concat(player.tilesToReset())
    player.x = newData.x
    player.y = newData.y
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
    @resetTiles = @resetTiles.concat(item.tilesToReset())

  moveRocket: (data) ->
    rocket = _.find @items, (i) -> i.id == data.id
    if rocket
      @resetTiles = @resetTiles.concat(rocket.tilesToReset())
      rocket.x = data.x
      rocket.y = data.y
    else
      @addNewRocket data

  getScores: ->
    @scoreBoard.getScores()

  setScores: (scores) ->
    @scoreBoard.setScores(scores)

  addCorpse: ({x, y, color}) ->
    @corpses.push(new Corpse(x, y, color))

  addExplosion: ({id, x, y}) ->
    @explosions.push(new Explosion(id, x, y))

  removeExplosion: (id) ->
    explosion = _.find(@explosions, (exp) -> exp.id == id)
    @explosions = _.without @explosions, explosion
    @resetTiles = @resetTiles.concat(explosion.tilesToReset())



module.exports = Game
