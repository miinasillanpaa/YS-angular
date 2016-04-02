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
      console.log 'scores', scope

      scope.$watch "successText", (successText) ->
        console.log

      scope.quit = ->
        scope.quitFn()
