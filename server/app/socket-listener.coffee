debug = require('debug')('sh:socket')
_ = require('underscore')

gameController = require('./game-controller')

class SocketListener
  constructor: (@io) ->

  connectionReceived: (socket) ->
    debug('Adding new connection to room "all"')
    socket.join("all")

    @sendMapToSocket(socket)
    @sendEvent('all', 'info', { message: 'New player arrived!' })

  startListening: ->
    debug("Starting listening for client connections")
    @io.sockets.on('connection', _.bind(@connectionReceived, @))

  sendEvent: (room, eventName, data) ->
    @io.sockets.in(room).emit(eventName, data)

  sendMapToSocket: (socket) ->
    debug('Sending map')
    map = gameController.getMap()
    socket.emit('map', map)

module.exports = SocketListener
