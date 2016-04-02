'use strict'

angular.module 'ysAngularApp'
  .directive 'scores', ->
    restrict: 'E'
    scope: {
      credits: "="
      successText: "="
      successRateText: "="
      quitFn: "&"
    }
    templateUrl: "views/scores.html"
    link: (scope, element, attrs) ->

      scope.quit = ->
        scope.quitFn()
