Base = require('./base')
class List extends Base
  constructor: ({@items}) ->
    super
    @render()

  render: ->
    for item, i in @items
      @display.drawText(@location.x, @location.y + i, item)

module.exports = List


