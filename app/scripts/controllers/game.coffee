'use strict'

angular.module 'ysAngularApp'
  .controller 'GameCtrl', ($scope, $routeParams, httpService, ngAudio, $filter, $timeout) ->

    AUDIO_GAP_MS = 2000

    $scope.showModal = true # debug, set to true
    $scope.playing = false
    $scope.fullReplayPlaying = false
    $scope.answered = "waiting"

    $scope.sound = null
    $scope.currentQuestion = null
    $scope.questionText = null
    $scope.questionIndex = 0
    $scope.showScores = false # debug set to false

    correctAnswers = 0
    questions = null

    $scope.gameType = gameType = $routeParams.gameType
    gameId = $routeParams.gameId

    # fetch game information
    httpService.getGames(gameType).then (games) ->
      $scope.game = games.data[gameId-1]
      mediaPath = $scope.game.media.toString()
      $scope.sound = ngAudio.load(mediaPath)
      $scope.fullReplayPath = mediaPath.substring(0, mediaPath.length-4).concat("_gapless.mp3")

    # fetch questions and intro
    httpService.getGame(gameType, gameId).then (game) ->
      $scope.intro = game.data.intro
      questions =  game.data.questions
      $scope.currentQuestion = questions[$scope.questionIndex]

    $scope.$watchGroup ["sound.currentTime", "questionIndex"], ([currentTime, questionIndex]) ->
      if questionIndex? and currentTime

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
              console.log 'prev index', $scope.questionIndex-1
              $scope.previousStarted = (questions[$scope.questionIndex-1].options.playTo + ($scope.questionIndex-1)*AUDIO_GAP_MS)/1000
            else
              $scope.previousStarted = 0
            console.log 'previous started', $scope.previousStarted

            console.log 'was paused at', pauseAt
            $scope.sound.pause()
            $scope.playing = false
            $scope.questionText = currentQuestion.questionText
            $scope.questionIndex++
            $scope.sound.currentTime = (currentQuestion.options.playTo + $scope.questionIndex*AUDIO_GAP_MS)/1000
        else
          if currentTime >= $scope.sound.duration-2
            $scope.successRate = correctAnswers/questions.length*100
            if $scope.successRate <= 50 then $scope.successText = "Harjoitellaan vielä"
            else if $scope.successRate <= 70 then "Mainiosti tiedetty"
            else if $scope.successText <= 90 then  "Erinomaista työtä!"
            else "Mahtavaa muistamista!"
            $scope.showScores = true

    $scope.$watch "sound.duration", (duration) ->

      if duration and !$scope.markers
        console.log 'durr', duration
        markers = []
        for question,index in questions
          marker = $filter('number')((question.options.playTo + (index*AUDIO_GAP_MS))/1000/duration *100,0) + "%"
          markers.push marker
        $scope.markers = markers

    # internal

    # public functions
    $scope.hideModal = ->
      $scope.showModal = false
      $scope.playing = true

    $scope.playIntervalAgain = ->
      console.log 'will play again from', $scope.previousStarted
      $scope.sound.currentTime = $scope.previousStarted
      $scope.questionIndex--
      $scope.sound.play()

    $scope.fullReplay = ->
      $scope.sound.stop()
      $scope.fullReplay = ngAudio.load($scope.fullReplayPath)
      $scope.fullReplay.play()
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
      console.log $scope.questionIndex, questions.length
      if $scope.questionIndex is questions.length
        $scope.questionText = "Kuuntele loppuun"
      else
        $scope.currentQuestion = questions[$scope.questionIndex]

    $scope.stopAll = ->
      $scope.sound
        .stop()
