expect = require('chai').expect
ROT = require('../../client/vendor/rot.js/rot')
Bacon = require('baconjs')
sinon = require('sinon')

SelectableList = require("../../client/ui/selectable_list")
KeyboardController = require("../../client/keyboard-controller")

describe "SelectableList", ->
  beforeEach ->
    @display = new ROT.Display()
    @controller = new KeyboardController()
    @inputs = setupBindStub(@controller)

    @items = ["foo", "bar", "baz"]
    @list = new SelectableList(
      display: @display,
      location: {x: 0, y: 0},
      items: @items,
      controller: @controller
    )

  it "renders items in the list", ->
    sinon.stub(@display, "drawText")
    @list.render()
    expect(@display.drawText.calledWith(2, 0, "foo")).to.be.true
    expect(@display.drawText.calledWith(2, 1, "bar")).to.be.true
    expect(@display.drawText.calledWith(2, 2, "baz")).to.be.true

  it "renders * for selected item", ->
    sinon.stub(@display, "draw")
    @list.render()
    expect(@display.draw.calledWith(0,0,"*")).to.be.true

  it "can change the selection with arrows", ->
    sinon.stub(@display, "draw")
    @inputs["DOWN"].push(true)
    expect(@display.draw.calledWith(0,1,"*")).to.be.true

  it "doesn't move the selection out of bounds", ->
    sinon.stub(@display, "draw")
    @inputs["UP"].push(true)
    expect(@display.draw.calledWith(0,-1,"*")).not.to.be.true

  it "resolves value with selected index when pressing Enter", ->
    value = @list.value()
    expect(value.state()).to.equal("pending")

    @inputs["RETURN"].push(true)
    expect(value.state()).to.equal("resolved")

  it "resolves return value with selected index", (done) ->
    @inputs["DOWN"].push(true)
    @inputs["RETURN"].push(true)

    @list.value().done (index) ->
      expect(index).to.equal(1)
      done()

setupBindStub = (controller) ->
  inputs = { UP: new Bacon.Bus(), DOWN: new Bacon.Bus(), RETURN: new Bacon.Bus() }
  sinon.stub controller, "bind", (button) ->
    inputs[button]

  inputs
