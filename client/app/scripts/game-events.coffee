Bacon = require('baconjs')

globalBus = new Bacon.Bus()

module.exports =
  socketMessage: (socket, key) ->
    bus = new Bacon.Bus()
    socket.on key, (data) ->
      bus.push { key: key, data: data }
    bus

  globalBus: globalBus
