'use strict'

angular.module 'ysAngularApp'
  .controller 'HeaderCtrl', ($scope, $location, $window) ->
    $scope.showBack = false
    $scope.headerTitle = "Sanat sekaisin"
    $scope.$watch (-> $location.path()), (newLocation, oldLocation) ->
      if newLocation isnt "/"
        $scope.showBack = true
      else
        $scope.showBack = false

      if newLocation.indexOf('action') > -1
        $scope.headerTitle = "Musiikin mukaan"
      else
        $scope.headerTitle = "Sanat sekaisin"

    $scope.back = ->
      # user might be linked straight to a gametype
      # else just use window.history.back()
      goto = switch $location.path()
        when '/games/plain' then '/'
        when '/games/music' then '/'
        when '/games/action' then '/'
        when '/games/lorut' then '/'

      if goto
        $location.path(goto)
      else
        $window.history.back()
