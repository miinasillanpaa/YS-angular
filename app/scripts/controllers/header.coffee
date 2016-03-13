'use strict'

angular.module 'ysAngularApp'
  .controller 'HeaderCtrl', ($scope, $location, $window) ->
    $scope.showBack = false
    $scope.$watch (-> $location.path()), (newLocation, oldLocation) ->
      if newLocation isnt "/"
        $scope.showBack = true

    $scope.back = ->
      # user might be linked straight to a gametype
      # else just use window.history.back()
      goto = switch $location.path()
        when '/games/plain' then '/'
        when '/games/music' then '/'
        when '/games/action' then '/'

      if goto
        $location.path(goto)
      else
        $window.history.back()
