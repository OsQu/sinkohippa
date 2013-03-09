process.env.NODE_ENV ||= "development"

express = require 'express'
app = express()

http = require 'http'
server = http.createServer app

socketio = require 'socket.io'
io = socketio.listen server

app.get '/', (req, res) ->
  res.send "TODO: Implement backend"

server.listen(process.env.PORT)
console.log "Started Sinkohippa backend to port:", process.env.PORT
