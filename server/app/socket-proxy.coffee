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
    debug("Got new connection #{socket.id}")
    @sockets.push(socket)
    bind(socket, 'disconnect').onValue (ev) => @handleDisconnection(ev)

  handleDisconnection: (ev) ->
    @sockets = _.filter(@sockets, (socket) -> socket.id != ev.socket.id)

  createGame: ->
    game = new GameManager(uuid.v4())
    game.globalBus.filter (ev) ->
      ev.type == "BROADCAST" && ev.key == "game-destroyed"
    .take(1).onValue (ev) => @destroyGame(game)

    @games.push(game)
    game

  destroyGame: (game)->
    debug("Destroying game: #{game.id}")
    game.destroy()
    @games = _.without(@games, game)

  joinGame: (playerId, playerName, gameId) ->
    playerSocket = _.find(@sockets, (s) -> s.id == playerId)
    game = _.find(@games, (g) -> g.id == gameId)
    if !playerSocket || !game then return false
    game.addPlayer(playerSocket, playerName)
    true



socketProxy = new SocketProxy()
module.exports = socketProxy
