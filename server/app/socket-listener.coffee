debug = require('debug')('sh:socket')
_ = require('underscore')
Bacon = require('baconjs')

gameController = require('./game-controller')

sendMapToSocket = (socket) ->
  debug('Sending map')
  map = gameController.getMap()
  socket.emit('map', map)

module.exports = (io) ->
  debug("Starting to listening for connections")
  io.sockets.on 'connection', (socket) ->
    debug('Adding new connection to room "all"')
    socket.join("all")
    sendMapToSocket socket


