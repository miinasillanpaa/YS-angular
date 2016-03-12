'use strict'

angular
  .module 'ysAngularApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch'
  ]
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

      .when '/games/:gameType/:gameId',
        templateUrl: 'views/game.html'
        controller: 'GameCtrl'
        controllerAs: 'game'

      .otherwise
        redirectTo: '/'
