socketProxy = require('../socket-proxy')

createGame = (req, res) ->
  newGame = socketProxy.createGame()
  res.send(200, gameId: newGame.id)

module.exports = (app) ->
  app.post '/game', createGame
