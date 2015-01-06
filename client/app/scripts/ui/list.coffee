Base = require('./base')
class List extends Base
  SELECTED_DOT_MARGIN = 2

  constructor: ({@items, @controller}) ->
    super
    @selected = 0
    @returnValue = $.Deferred()
    @returnValue.done => @destructor()

    @bindKeyPresses()
    @render()

  bindKeyPresses: ->
    for direction in ["UP", "DOWN"]
      @controller.bind(direction).takeUntil(@destruct).map(direction).onValue (press) =>
        switch press
          when "UP" then @selected -= 1 unless @selected <= 0
          when "DOWN" then @selected += 1 unless @selected >= @items.length - 1

        @render()

    @controller.bind("RETURN").takeUntil(@destruct).onValue =>
      @returnValue.resolve(@selected)

  render: ->
    for item, i in @items
      @display.drawText(@location.x + SELECTED_DOT_MARGIN, @location.y + i, item)
      if i == @selected
        @display.draw(@location.x, @location.y + i, "*")
      else
        @display.draw(@location.x, @location.y + i, " ")

  value: ->
    @returnValue.promise()

module.exports = List


