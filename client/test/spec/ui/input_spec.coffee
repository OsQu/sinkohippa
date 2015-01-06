expect = require('chai').expect
ROT = require('../../client/vendor/rot.js/rot')
Bacon = require('baconjs')
sinon = require('sinon')

Input = require("../../client/ui/input")
KeyboardController = require('../../client/keyboard-controller')

describe 'Input', ->
  beforeEach ->
    @display = new ROT.Display()
    @controller = new KeyboardController()
    @inputBus = new Bacon.Bus()
    sinon.stub(@controller, "onInput", => @inputBus)
    @input = new Input(display: @display, controller: @controller, location: {x: 0, y: 0})

  it "updates text on key down", ->
    @inputBus.push(65) # 65 = A
    expect(@input.text).to.equal("A")

  it "draws text to screen", ->
    sinon.stub(@display, "draw")
    @inputBus.push(65)
    expect(@display.draw.calledWith(0,0,"A")).to.be.true

  it "resolves promise when Enter is pressed", ->
    value = @input.value()
    expect(value.state()).to.equal("pending")
    @inputBus.push(65)
    @inputBus.push(13) # = ENTER
    expect(value.state()).to.equal("resolved")

  it "resolves return value promise with text", (done) ->
    @inputBus.push(65)
    @inputBus.push(13)

    @input.value().done (text) ->
      expect(text).to.equal("A")
      done()
