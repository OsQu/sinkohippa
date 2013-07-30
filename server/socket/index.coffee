debug = require('debug')('sh:socket')
_ = require('underscore')

sendNewPlayerEvent = ->

class SocketListener
  constructor: (@io) ->

  connectionReceived: (socket) ->
    debug('Adding new connection to room "all"')
    socket.join("all")

    @sendEvent('all', 'info', { message: 'New player arrived!' })

  startListening: ->
    debug("Starting listening for client connections")
    @io.sockets.on('connection', _.bind(@connectionReceived, @))

  sendEvent: (room, eventName, data) ->
    @io.sockets.in(room).emit(eventName, data)

module.exports = SocketListener
