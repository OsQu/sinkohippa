process.env.NODE_ENV ||= "development"

express = require 'express'
app = express()

# Express middlewares
app.use(express.bodyParser())

debug = require('debug')('sh:main')

http = require 'http'
server = http.createServer app

socketio = require 'socket.io'
io = socketio.listen server, { log: false }

require('./routes')(app)

socketProxy = require('./socket-proxy')
socketProxy.startListeningSockets(io)
server.listen(process.env.PORT)
debug("Started Sinkohippa backend to port: #{process.env.PORT}")
