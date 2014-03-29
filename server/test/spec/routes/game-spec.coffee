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

mockSocket =
  id: 'socket-1'
  emit: sinon.spy()
  on: sinon.spy()


describe 'Game routes', ->
  beforeEach ->
    uuid.v4 = -> 'test1'
  afterEach ->
    socketProxy.sockets = []
    socketProxy.games = []

  it 'POST /game, create game', (done) ->
    request(app)
      .post('/game')
      .expect(gameId: 'test1')
      .end done

  it 'PUT /game, join game', (done) ->
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


