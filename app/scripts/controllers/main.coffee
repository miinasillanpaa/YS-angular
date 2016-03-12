'use strict'

angular.module 'ysAngularApp'
  .controller 'MainCtrl', ($scope, httpService) ->

    httpService.getGameTypes().then (gametypes) ->
      $scope.gametypes = gametypes.data
