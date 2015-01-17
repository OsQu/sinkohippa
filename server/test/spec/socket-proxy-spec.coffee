should = require('should')
sinon = require('sinon')
_ = require('underscore')
Bacon = require('baconjs')

socketProxy = require('../../app/socket-proxy')
mockSocketCreator = require('./spec-helpers').createMockSocket

describe 'SocketProxy', ->
  afterEach ->
    socketProxy.sockets = []
    socketProxy.games = []

  it 'should accept new connection', ->
    mockSocket = mockSocketCreator('socket')
    socketProxy.newConnection(mockSocket)
    socketProxy.sockets.length.should.eql(1)

  it 'should handle disconnection', ->
    socketProxy.sockets.push
      id: 1
    socketProxy.sockets.push
      id: 2
    socketProxy.handleDisconnection
      socket:
        id: 1
    socketProxy.sockets.length.should.eql(1)

  it 'should create game', ->
    socketProxy.createGame()
    socketProxy.games.length.should.eql(1)
    socketProxy.games[0].id.should.exists

  it 'should destroy a game', ->
    game = socketProxy.createGame()
    socketProxy.destroyGame(game)
    socketProxy.games.length.should.eql(0)
