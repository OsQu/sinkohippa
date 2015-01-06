Bacon = require('baconjs')

class Base
  constructor: ({@display, @location}) ->
    @destruct = new Bacon.Bus()

  destructor: -> @destruct.push(true)

module.exports = Base
