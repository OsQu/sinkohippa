expect = require('chai').expect
ROT = require('../../client/vendor/rot.js/rot')
Bacon = require('baconjs')
sinon = require('sinon')

List = require("../../client/ui/list")
KeyboardController = require("../../client/keyboard-controller")

describe "List", ->
  beforeEach ->
    @display = new ROT.Display()

    @items = ["foo", "bar", "baz"]
    @list = new List(
      display: @display,
      location: {x: 0, y: 0},
      items: @items
    )

  it "renders items in the list", ->
    sinon.stub(@display, "drawText")
    @list.render()
    expect(@display.drawText.calledWith(0, 0, "foo")).to.be.true
    expect(@display.drawText.calledWith(0, 1, "bar")).to.be.true
    expect(@display.drawText.calledWith(0, 2, "baz")).to.be.true
