process.env.NODE_ENV ||= "development"

express = require 'express'
app = express()

debug = require('debug')('sh:main')

http = require 'http'
server = http.createServer app

socketio = require 'socket.io'
io = socketio.listen server, { log: false }

require('./routes')(app)
SocketListener = require('./socket')
socketListener = new SocketListener(io)
socketListener.startListening()

server.listen(process.env.PORT)
debug("Started Sinkohippa backend to port: #{process.env.PORT}")
