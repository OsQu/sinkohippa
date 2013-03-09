process.env.NODE_ENV ||= "development"

express = require 'express'

app = express()

app.get '/', (req, res) ->
  res.send "TODO: Implement backend"

app.listen(process.env.PORT)
console.log "Started Sinkohippa backend to port:", process.env.PORT
