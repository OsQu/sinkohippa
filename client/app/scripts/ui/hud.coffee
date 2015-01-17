Base = require('./base')
gameEvents = require('../game-events')

class Hud extends Base
  constructor: ->
    super
    gameEvents.globalBus.filter((ev) -> ev.target == 'hud').onValue (ev) =>
      @render(ev.data)

  render: (hudData) ->
    hudString = "HP:#{hudData.health}"
    @display.drawText(@location.x, @location.y, hudString)

module.exports = Hud
