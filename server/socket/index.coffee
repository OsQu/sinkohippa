debug = require('debug')('sh:socket')

connectionReceived = (socket) ->
  debug('Got new connection')
  socket.emit('info', { message: 'Hello!' })

module.exports = (io) ->
  io.sockets.on('connection', connectionReceived)
