'use strict'

angular.module 'ysAngularApp'
  .factory 'httpService', ($http) ->
    # Service logic
    # ...
    httpService = {}
    localUrl = "/json"

    httpService.getGameTypes = ->
      $http.get "#{localUrl}/gameTypes.json"
        .success (data) ->
          return data
        .error (error) ->
          console.error 'failed to load gameTypes', error

    httpService.getGames = (gameType) ->
      $http.get "#{localUrl}/#{gameType}Games.json"
        .success (data) ->
          return data
        .error (error) ->
          console.log "failed to load gameType: #{gameType}", error

    httpService.getGame = (gameType, gameId) ->
      $http.get "#{localUrl}/#{gameType}/#{gameId}.json"
        .success (data) ->
          return data
        .error (error) ->
          console.log "failed to load #{gameType}/#{gameId}.json", error

    httpService
