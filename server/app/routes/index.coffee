root = (req, res) ->
  res.send "Use web sockets!"

module.exports = (app) ->
  app.get '/', root
  require('./game.coffee')(app)
