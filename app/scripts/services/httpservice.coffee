'use strict'

angular.module 'ysAngularApp'
  .factory 'httpService', ($http) ->

    httpService = {}
    localUrl = "json"

    httpService.getGameTypes = ->
      $http.get "#{localUrl}/gameTypes.json"
        .then (data) ->
          return data
        , (error) ->
          console.error 'failed to load gameTypes'

    httpService.getGames = (gameType) ->
      $http.get "#{localUrl}/#{gameType}Games.json"
        .then (data) ->
          return data
        , (error) ->
          console.error "failed to load gameType: #{gameType}"

    httpService.getGame = (gameType, gameId) ->
      $http.get "#{localUrl}/#{gameType}/#{gameId}.json"
        .then (data) ->
          return data
        , (error) ->
          console.error "failed to load #{gameType}/#{gameId}.json"

    httpService
