'use strict'

angular.module 'ysAngularApp'
  .controller 'GamesCtrl', ($scope, $routeParams, httpService) ->
    $scope.gametype = $routeParams.gameType

    httpService.getGames($scope.gametype).then (games) ->
      console.log games
      $scope.games = games.data
