debug = require('debug')('sh:socket')
_ = require('underscore')
Bacon = require('baconjs')

gameController = require('./game-controller')

bind = (io, socket, key) ->
  bus = new Bacon.Bus()
  socket.on key, (data) ->
    bus.push { io: io, socket: socket, key: key, data: data }
  bus

sendMapToSocket = (socket) ->
  debug('Sending map')
  map = gameController.getMap()
  socket.emit('map', map)

sendPlayerIdToSocket = (socket) ->
  id = socket.id
  debug("Sending player id #{socket.id} to socket")
  socket.emit('player-id', id)

handlePlayerEvent = (ev) ->
  debug("Got player event")
  if ev.data.action == 'move'
    gameController.movePlayer(ev.socket.id, ev.data.direction)

  broadcastGameState(ev.io)

handleDisconnection = (ev) ->
  debug("Player #{ev.socket.id} is disconnecting")
  gameController.removePlayer(ev.socket.id)
  broadcastGameState(ev.io)

broadcastGameState = (io) ->
  debug("Broadcasting the game state to all clients")

  state = gameController.getGameState()
  io.sockets.in('all').emit('state', state)

module.exports = (io) ->
  debug("Starting to listening for connections")
  io.sockets.on 'connection', (socket) ->
    debug('Adding new connection to room "all"')
    socket.join("all")

    gameController.addPlayer(socket.id)
    sendMapToSocket socket
    sendPlayerIdToSocket socket
    broadcastGameState(io)

    #bind(io, socket, 'player').onValue handlePlayerEvent
    #bind(io, socket, 'disconnect').onValue handleDisconnection
