Bacon = require('baconjs')
gameEvents = require('./game-events')

class Controls
  constructor: (opts) ->
    @serverUrl = opts.serverUrl

    $('#controls .create-game')
      .asEventStream('click')
      .flatMap(=>
        Bacon.fromPromise($.post("#{@serverUrl}/game"))
      ).onValue => @listGames()

  listGames: ->
    Bacon.fromPromise($.get("#{@serverUrl}/game")).onValue (games) =>
      $("#games .game-table").empty()
      for gameId in games
        $('#games .game-table').append("<li data-game-id=\"#{gameId}\" class=\"join-game\">#{gameId}</li>")
      @bindJoinGame()

  bindJoinGame: ->
    @joinGameUnsub?()
    @joinGameUnsub = $('#games .join-game')
      .asEventStream('click')
      .map((ev) ->
        $(ev.target).data('game-id')
      ).onValue (gameId) =>
        gameEvents.globalBus.push
          target: 'join-game'
          data:
            url: "#{@serverUrl}/game"
            gameId: gameId

module.exports = Controls
