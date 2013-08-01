class PlayerActor
  constructor: (@manager, @id) ->
    @type = 'player'
    @x = 1
    @y = 1

    @manager.globalBus.filter((ev) => ev.id == @id).filter((ev) => ev.type == 'PLAYER_MOVE').onValue @movePlayer

  movePlayer: (ev) ->
    console.log("moving player")

module.exports = PlayerActor
