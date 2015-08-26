debug = require('debug')('sh-game')
_ = require('underscore')

socketProxy = require('../socket-proxy')

createGame = (req, res) ->
  debug("Creating game")
  newGame = socketProxy.createGame()
  res.send(200, gameId: newGame.id)

joinGame = (req, res) ->
  debug("Joining game, player: #{req.body.player_name}")
  if !req.body.player_id || !req.body.game_id || !req.body.player_name then return res.send(404)
  success = socketProxy.joinGame(req.body.player_id, req.body.player_name, req.body.game_id)
  if success
    res.send(200)
  else
    res.send(404)


listGames = (req, res) ->
  games = socketProxy.games
  gameIds = _.pluck(games, 'id')
  res.send(200, gameIds)


module.exports = (app) ->
  app.all '/game', (req, res, next) ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Methods", "POST, GET, PUT")
    res.header("Access-Control-Allow-Headers", "X-Requested-With")
    if (req.method == 'OPTIONS') then return res.send(200)
    next()

  app.get '/game', listGames
  app.post '/game', createGame
  app.put '/game', joinGame
