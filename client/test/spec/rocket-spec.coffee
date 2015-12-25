expect = require('chai').expect

ROT = require('../client/vendor/rot.js/rot')
Bacon = require('baconjs')
Rocket = require('../client/rocket')
Player = require('../client/player')

describe 'Rocket', ->
  beforeEach ->
    shooter = new Player("manny", "white", 0, 0)
    @rocket = new Rocket(0, 1, 1, shooter, 'right')

  it 'should have correct char when flying horizontally', ->
    expect(@rocket.getChar()).to.be.equal '-'

  it 'should have correct char when flying vertically', ->
    @rocket.direction = 'down'
    expect(@rocket.getChar()).to.be.equal '|'

  it 'should render rocket', (done) ->
    mockDisplay =
      draw: (x, y, char) ->
        expect(char).to.be.equal '-'
        done()
    @rocket.render(mockDisplay)
