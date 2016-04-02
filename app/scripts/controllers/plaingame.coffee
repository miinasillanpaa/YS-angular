'use strict'

angular.module 'ysAngularApp'
  .controller 'PlainGameCtrl', ($scope, $routeParams, httpService, $location, $filter) ->

    gameType = "plain"
    gameId = $routeParams.gameId
    correctAnswers = 0
    questions = null

    $scope.showModal = true
    $scope.questionsLength = null
    $scope.questionIndex = 0
    $scope.answerWas = null
    $scope.showScores = false
    # correct, wrong or waiting
    $scope.answered = "waiting"
    $scope.disableAnswers = false

    # fetch game information
    httpService.getGames(gameType).then (games) ->
      $scope.game = games.data[gameId-1]

    # Fisher-Yates shuffle
    shuffleArray = (array) ->
      currentIndex = array.length
      # while there remain elements to shuffle
      while 0 isnt currentIndex
        # pick remaining element
        randomIndex = Math.floor(Math.random() * currentIndex)
        currentIndex -= 1
        # and swap it with the current element
        temporaryValue = array[currentIndex]
        array[currentIndex] = array[randomIndex]
        array[randomIndex] = temporaryValue
      array

    # fetch questions and intro
    httpService.getGame(gameType, gameId).then (game) ->
      $scope.intro = game.data.intro
      questions = shuffleArray(game.data.questions)
      $scope.questionsLength = questions.length
      $scope.currentQuestion = questions[$scope.questionIndex]

    $scope.checkAnswer = (answer, $event) ->
      if answer.correct
        correctAnswers++
        $scope.answered = "correct"
        $scope.answerWas = "Oikein!"
        $($event.target)
          .removeClass "btn-default"
          .addClass "btn-success"
      else
        $scope.answered = "wrong"
        $scope.answerWas = "Ei onnistunut"
        $($event.target)
          .removeClass "btn-default"
          .addClass "btn-danger"
      $scope.disableAnswers = true

    $scope.setNextQuestion = ->
      $scope.questionIndex++
      $scope.answerWas = null
      $scope.answered = "waiting"
      $scope.disableAnswers = false
      if $scope.questionIndex is questions.length
        $scope.successRate = correctAnswers/questions.length*100
        $scope.successRateFiltered = $filter('number')($scope.successRate, 0)
        $scope.successRateText = "Sait oikeita vastauksia #{$scope.successRateFiltered}%"
        if $scope.successRate <= 50
          $scope.successText = "Harjoitellaan vielä"
        else if $scope.successRate <= 70
          $scope.successText = "Mainiosti tiedetty"
        else if $scope.successText <= 90
          $scope.successText = "Erinomaista työtä!"
        else
          $scope.successText = "Mahtavaa muistamista!"
        $scope.showScores = true
      else
        $scope.currentQuestion = questions[$scope.questionIndex]

    $scope.quit = ->
      $location.path "/games/#{gameType}"
