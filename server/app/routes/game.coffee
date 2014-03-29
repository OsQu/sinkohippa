_ = require('underscore')

socketProxy = require('../socket-proxy')

createGame = (req, res) ->
  newGame = socketProxy.createGame()
  res.send(200, gameId: newGame.id)

joinGame = (req, res) ->
  if !req.body.player_id || !req.body.game_id then return res.send(404)

  playerSocket = _.find(socketProxy.sockets, (s) -> s.id == req.body.player_id)
  game = _.find(socketProxy.games, (g) -> g.id == req.body.game_id)
  if !playerSocket then return res.send(404, "Player not found")
  if !game then return res.send(404, "Game not found")
  game.addPlayer(playerSocket)
  res.send(200)

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
