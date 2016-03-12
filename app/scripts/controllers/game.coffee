'use strict'

angular.module 'ysAngularApp'
  .controller 'GameCtrl', ($scope, $routeParams, httpService) ->
    $scope.showModal = false # debug, set to true
    gameType = $routeParams.gameType
    gameId = $routeParams.gameId

    # fetch game information
    httpService.getGames(gameType).then (games) ->
      $scope.game = games.data[gameId-1]
      console.log $scope.game
    # fetch questions and intro
    httpService.getGame(gameType, gameId).then (game) ->
      $scope.intro = game.data.intro
      $scope.questions = game.data.questions



    # public functions
    $scope.start = ->
      $scope.showModal = false
