'use strict'

angular.module 'ysAngularApp'
  .controller 'MusicGameCtrl',
  ($scope, $routeParams, httpService, ngAudio, $filter, $timeout, $rootScope, $location) ->

    AUDIO_GAP_MS = 2000
    # lorut or music
    gameType = $location.path().substring(7,12)
    gameId = $routeParams.gameId

    $rootScope.inGame = true
    $scope.showModal = true # debug, set to true
    $scope.endGameConfirm = false

    $scope.playing = false
    $scope.fullReplayPlaying = false
    # correct, wrong or waiting
    $scope.answered = "waiting"

    $scope.sound = null
    $scope.currentQuestion = null
    $scope.questionText = null
    $scope.questionIndex = 0
    $scope.showScores = false # debug set to false

    correctAnswers = 0
    questions = null

    # fetch game information
    httpService.getGames(gameType).then (games) ->
      $scope.game = games.data[gameId-1]
      mediaPath = $scope.game.media.toString()
      $rootScope.sound = $scope.sound = ngAudio.load(mediaPath)
      $scope.fullReplayPath = mediaPath.substring(0, mediaPath.length-4).concat("_gapless.mp3")

    # fetch questions and intro
    httpService.getGame(gameType, gameId).then (game) ->
      $scope.intro = game.data.intro
      questions =  game.data.questions
      $scope.currentQuestion = questions[$scope.questionIndex]

    $scope.$watchGroup ["sound.currentTime", "questionIndex"], ([currentTime, questionIndex]) ->
      if questionIndex? and currentTime
        # playing
        if questionIndex < questions.length
          currentQuestion = questions[questionIndex]
          if questionIndex > 0
            pauseAt = currentQuestion.options.playTo + (questionIndex*AUDIO_GAP_MS)
          else
            pauseAt = currentQuestion.options.playTo

          if $scope.playing
            timeToPause = $filter('number')(pauseAt/1000 - currentTime, 0)
            $scope.questionText = "#{timeToPause} sekuntia taukoon. Valmistaudu vastaamaan!"

          if currentTime*1000 >= pauseAt

            # previous started
            if questions[$scope.questionIndex-1]
              $scope.previousStarted = (questions[$scope.questionIndex-1].options.playTo + ($scope.questionIndex-1)*AUDIO_GAP_MS)/1000
            else
              $scope.previousStarted = 0

            $scope.sound.pause()
            $scope.playing = false
            $scope.questionText = currentQuestion.questionText
            $scope.questionIndex++
            $scope.sound.currentTime = (currentQuestion.options.playTo + $scope.questionIndex*AUDIO_GAP_MS)/1000
        else
          # end
          if currentTime >= $scope.sound.duration-2
            $scope.successRate = correctAnswers/questions.length*100

            if $scope.successRate <= 50
              $scope.successText = "Harjoitellaan vielä"
            else if $scope.successRate <= 70
              $scope.successText = "Mainiosti tiedetty"
            else if $scope.successText <= 90
              $scope.successText = "Erinomaista työtä!"
            else
              $scope.successText = "Mahtavaa muistamista!"
            $scope.showScores = true

    # internal
    stopAll = ->
      if $scope.sound and $scope.playing
        $scope.sound.stop()

    # public functions
    $scope.hideModal = ->
      $scope.showModal = false
      $scope.playing = true

    $scope.playIntervalAgain = ->
      $scope.sound.currentTime = $scope.previousStarted
      $scope.questionIndex--
      $scope.sound.play()

    $scope.fullReplay = ->
      $scope.sound.stop()
      $scope.sound = ngAudio.load($scope.fullReplayPath)
      $scope.sound.play()
      $scope.fullReplayPlaying = true

    $scope.checkAnswer = (answer, $event) ->
      if answer.correct
        correctAnswers++
        $scope.answered = "correct"
        $scope.questionText = "Oikein!"
        $($event.target)
          .removeClass "btn-default"
          .addClass "btn-success"
      else
        $scope.answered = "wrong"
        $scope.questionText = "Väärin meni."
        $($event.target)
          .removeClass "btn-default"
          .addClass "btn-danger"
      return false

    $scope.setNextQuestion = ->
      if $scope.questionIndex is questions.length
        $scope.questionText = "Kuuntele loppuun"
      else
        $scope.currentQuestion = questions[$scope.questionIndex]

    $scope.resume = ->
      $scope.endGameConfirm = false
      $scope.sound.play()

    $scope.quit = ->
      stopAll()
      $scope.endGameConfirm = false
      $rootScope.userConfirmedQuit = true
      $location.path "/games/#{gameType}"

    $rootScope.$on 'showConfirm', ->
      $scope.sound.pause()
      $scope.endGameConfirm = true
