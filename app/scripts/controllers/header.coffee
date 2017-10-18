'use strict'

angular.module 'ysAngularApp'
  .controller 'HeaderCtrl', ($scope, $location, $window) ->
    $scope.isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent)
    $scope.headerTitle = "Sanat sekaisin"
    
    $scope.$watch (-> $location.path()), (newLocation, oldLocation) ->
      $scope.locationPath = newLocation
      if newLocation.indexOf('action') > -1
        $scope.headerTitle = "Musiikin mukaan"
      else
        $scope.headerTitle = "Sanat sekaisin"

    $scope.back = ->
      # user might be linked straight to a gametype
      # else just use window.history.back()
      if $location.path() is '/'
        $window.location.href =  'http://www.miinasillanpaa.fi'
        return

      goto = switch $location.path()
        when '/games/plain' then '/'
        when '/games/music' then '/'
        when '/games/action' then '/'
        when '/games/lorut' then '/'

      if goto
        $location.path(goto)
      else
        $window.history.back()
