gameEvents = require('./game-events')

class Hud
  constructor: ->
    gameEvents.globalBus.filter((ev) -> ev.target == 'hud').onValue @updateHud

  updateHud: (ev) =>
    hudData = ev.data
    if hudData.health
      $('.player-health').html(hudData.health)

module.exports = Hud
