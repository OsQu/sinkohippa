process.env.NODE_ENV ||= "development"

express = require 'express'
app = express()

debug = require('debug')('sh:main')

http = require 'http'
server = http.createServer app

socketio = require 'socket.io'
io = socketio.listen server, { log: false }

require('./routes')(app)

actorManager = require('./actors/actor-manager')

actorManager.globalBus.push({ type: 'START_LISTENING_SOCKETS', io: io})

server.listen(process.env.PORT)
debug("Started Sinkohippa backend to port: #{process.env.PORT}")
