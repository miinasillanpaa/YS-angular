'use strict'

angular.module 'ysAngularApp'
  .controller 'GamesCtrl', ($scope, $routeParams, httpService) ->
    $scope.gameType = $routeParams.gameType

    console.log $scope.gameType

    httpService.getGames($scope.gameType).then (games) ->
      console.log games.data
      $scope.games = games.data
