process.env.NODE_ENV ||= "development"

express = require 'express'
app = express()

http = require 'http'
server = http.createServer app

socketio = require 'socket.io'
io = socketio.listen server

require('./routes')(app)

server.listen(process.env.PORT)
console.log "Started Sinkohippa backend to port:", process.env.PORT
