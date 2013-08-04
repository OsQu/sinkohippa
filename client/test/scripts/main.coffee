console.log 'Overriding mainjs'

mocha.setup('bdd')

require('../spec/game-spec')
require('../spec/map-spec')
require('../spec/player-spec')
require('../spec/events-spec')
require('../spec/rocket-spec')

mocha.run()
