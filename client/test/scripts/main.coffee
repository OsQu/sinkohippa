console.log 'Overriding mainjs'

mocha.setup('bdd')

require('../spec/game-spec')
require('../spec/map-spec')
require('../spec/player-spec')
require('../spec/events-spec')
require('../spec/rocket-spec')
require('../spec/message-handler-spec')
require('../spec/hud-spec')
require('../spec/lobby_spec')
require('../spec/ui/input_spec')
require('../spec/ui/list_spec')

mocha.run()
