GameManager = require('../../app/actors/game-manager')
RocketActor = require('../../app/actors/rocket-actor')
PlayerActor = require('../../app/actors/player-actor')

class Factory
  rocketActor: ({gameManager, id, shooterId, x, y, direction} = {}) ->
    gameManager = gameManager || new GameManager(0)
    id = id || 0
    shooterId = shooterId || 1
    x = x || 0
    y = y || 0
    direction = direction || 'up'
    new RocketActor(gameManager, id, shooterId, x, y, direction)

  playerActor: ({gameManager, id, x, y, health} = {}) ->
    gameManager = gameManager || new GameManager(0)
    id = id || 0
    player = new PlayerActor(gameManager, id)
    player.x = x if x
    player.y = y if y
    player.health = health if health
    player



factory = new Factory
module.exports = factory
