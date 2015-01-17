Bacon = require("baconjs")
gameEvents = require("../client/game-events")

mocks =
  mockGameEvents: ->
    beforeEach ->
      @oldBus = gameEvents.globalBus
      gameEvents.globalBus = new Bacon.Bus()

    afterEach ->
      gameEvents.globalBus = @oldBus

module.exports = mocks
