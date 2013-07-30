debug = require('debug')('sh:socket')
_ = require('underscore')
Bacon = require('baconjs')

gameController = require('./game-controller')

bind = (socket, key) ->
  bus = new Bacon.Bus()
  socket.on key, (data) ->
    bus.push { socket: socket, key: key, data: data }
  bus

sendMapToSocket = (socket) ->
  debug('Sending map')
  map = gameController.getMap()
  socket.emit('map', map)

handlePlayerEvent = (ev) ->
  debug("Got player event")
  if ev.data.action == 'move'
    gameController.movePlayer(ev.socket.id, ev.data.direction)
module.exports = (io) ->
  debug("Starting to listening for connections")
  io.sockets.on 'connection', (socket) ->
    debug('Adding new connection to room "all"')
    socket.join("all")

    gameController.addPlayer(socket.id)
    sendMapToSocket socket

    bind(socket, 'player').onValue handlePlayerEvent


