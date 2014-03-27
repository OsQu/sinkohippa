debug = require('debug')('sh:socket-proxy')
Bacon = require('baconjs')
_ = require('underscore')
uuid = require('node-uuid')

GameManager = require('./actors/game-manager')

bind = (socket, key) ->
  bus = new Bacon.Bus()
  socket.on key, (data) ->
    bus.push { socket: socket, key: key, data: data }
  bus

class SocketProxy
  constructor: ->
    @sockets = []
    @games = []

  startListeningSockets: (io) ->
    @io = io
    @io.sockets.on 'connection', (ev) => @newConnection(ev)

  newConnection: (socket) ->
    debug("Got new connection")
    console.log @sockets
    @sockets.push(socket)
    bind(socket, 'disconnect').onValue (ev) => @handleDisconnection(ev)

  handleDisconnection: (ev) ->
    @sockets = _.filter(@sockets, (socket) -> socket.id != ev.socket.id)

  createGame: ->
    game = new GameManager(uuid.v4())
    @games.push(game)
  joinToGame: (socketId, gameId) ->


socketProxy = new SocketProxy()
module.exports = socketProxy
