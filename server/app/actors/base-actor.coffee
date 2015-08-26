debug = require('debug')('sh:base-actor')

class BaseActor
  constructor: ->
    @subscribers = []

  destroy: ->
    debug('destroying base actor')
    unsubscribe() for unsubscribe in @subscribers

  subscribe: (unsubscribe) ->
    @subscribers.push unsubscribe

module.exports = BaseActor
