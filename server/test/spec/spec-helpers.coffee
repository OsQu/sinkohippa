sinon = require('sinon')

module.exports =
  createMockSocket: (id) ->
    id: id
    emit: sinon.spy()
    on: sinon.spy()

