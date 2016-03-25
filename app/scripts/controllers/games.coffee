'use strict'

angular.module 'ysAngularApp'
  .controller 'GamesCtrl', ($scope, $routeParams, httpService) ->
    $scope.gameType = $routeParams.gameType
    httpService.getGames($scope.gameType).then (games) ->
      $scope.games = games.data
