gotInfo = (info) ->
  console.log("From socket")
  console.log(info)

module.exports =
  handleEvents: (socket) ->
    socket.on('info', gotInfo)
