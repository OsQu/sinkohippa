Base = require('./base')

class Header extends Base
  constructor: ({@text}) ->
    super
    @render()

  render: ->
    @display.drawText(@location.x, @location.y, @text)
    underline = new Array(@text.length + 1).join("-")

    @display.drawText(@location.x, @location.y + 1, underline)

module.exports = Header
