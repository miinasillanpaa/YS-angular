'use strict'

angular
  .module 'ysAngularApp', [
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ngAudio',
    'youtubePlayer'
  ]
  .run ($rootScope, $route, $location, $window, $timeout) ->
    firstLocationChangeStartDone = false
    $rootScope.$on '$locationChangeStart', (event) ->
      if firstLocationChangeStartDone and $rootScope.inGame
        if $rootScope.userConfirmedQuit
          $rootScope.userConfirmedQuit = false
          $rootScope.inGame = false
        else
          $rootScope.$broadcast('showConfirm')
          event.preventDefault()

      firstLocationChangeStartDone = true

    $rootScope.$on '$locationChangeSuccess', ->
      # TODO add analytics
      # $window.ga('send', 'pageview', { page: $location.url() })
      $rootScope.actualLocation = $location.path()

  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        controllerAs: 'main'

      .when '/games/:gameType',
        templateUrl: 'views/games.html'
        controller: 'GamesCtrl'
        controllerAs: 'games'

      .when '/games/music/:gameId',
        templateUrl: 'views/musicgame.html'
        controller: 'MusicGameCtrl'
        controllerAs: 'musicgame'

      .when '/games/plain/:gameId',
        templateUrl: 'views/plaingame.html'
        controller: 'PlainGameCtrl'
        controllerAs: 'plaingame'

      .when '/games/action/:gameId',
        templateUrl: 'views/actiongame.html'
        controller: 'ActionGameCtrl'
        controllerAs: 'actiongame'

      .when '/games/lorut/:gameId',
        templateUrl: 'views/musicgame.html'
        controller: 'MusicGameCtrl'
        controllerAs: 'musicgame'

      .otherwise
        redirectTo: '/'
