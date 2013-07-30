Bacon = require('baconjs')

module.exports =
  on: (socket, key) ->
    bus = new Bacon.Bus()
    socket.on key, (data) ->
      bus.push { key: key, data: data }
    bus

