should = require('should')
_ = require('underscore')
express = require('express')
request = require('supertest')
uuid = require('node-uuid')

app = express()
gameRoutes = require('../../../app/routes/game')(app)

describe 'Game routes', ->
  beforeEach ->
    uuid.v4 = -> 'test1'

  it 'POST /game', (done) ->
    request(app)
      .post('/game')
      .expect(gameId: 'test1')
      .end done
