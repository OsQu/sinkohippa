should = require('should')
sinon = require('sinon')
_ = require('underscore')
express = require('express')
request = require('supertest')
uuid = require('node-uuid')

app = express()
app.use(express.bodyParser())
gameRoutes = require('../../../app/routes/game')(app)
socketProxy = require('../../../app/socket-proxy')
GameManager = require('../../../app/actors/game-manager')

mockSocketCreator = require('../spec-helpers').createMockSocket

describe 'Game routes', ->
  beforeEach ->
    uuid.v4 = -> 'test1'
  afterEach ->
    socketProxy.sockets = []
    socketProxy.games = []

  it 'should create game with POST /game', (done) ->
    request(app)
      .post('/game')
      .expect(gameId: 'test1')
      .end done

  it 'should join game with PUT /game', (done) ->
    mockSocket = mockSocketCreator('socket-1')
    socketProxy.sockets.push(mockSocket)
    socketProxy.games.push(new GameManager('game-1'))
    request(app)
      .put('/game')
      .send({
        game_id: 'game-1',
        player_id: 'socket-1'
      })
      .expect(200)
      .end done

  it 'list games with GET /game', (done) ->
    for i in [0..2]
      socketProxy.games.push(new GameManager("game-#{i}"))
    request(app)
      .get('/game')
      .expect(200)
      .expect(["game-0", "game-1", "game-2"])
      .end done
