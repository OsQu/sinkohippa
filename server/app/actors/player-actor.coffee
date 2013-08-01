class PlayerActor
  constructor: (@manager, @id) ->
    @type = 'player'
    @x = 1
    @y = 1
    @manager.globalBus.push { type: 'BROADCAST', key: 'new-player', data: @getState() }

    @bindEvents()

  bindEvents: ->
    @manager.globalBus.filter((ev) => ev.id == @id).filter((ev) => ev.type == 'PLAYER_MOVE').onValue @movePlayer

  getState: ->
    state =
      id: @id
      x: @x
      y: @y
    state

  movePlayer: (ev) ->
    debug "Moving player #{@id}"
    mapActor = @manager.getMapActor()
    switch ev.direction
      when 'up' then if mapActor.canMove(@x, @y - 1) then @y--
      when 'down' then if mapActor.canMove(@x, @y + 1) then @y++
      when 'left' then if mapActor.canMove(@x - 1, @y) then @x--
      when 'right' then if mapActor.canMove(@x + 1, @y) then @x++

module.exports = PlayerActor
