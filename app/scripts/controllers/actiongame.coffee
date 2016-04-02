'use strict'

angular.module 'ysAngularApp'
  .controller 'ActionGameCtrl',
  ($scope, $routeParams, httpService, ngAudio, $location, $rootScope, $window) ->

    gameType = "action"
    $scope.gameId = gameId = $routeParams.gameId
    questions = null

    $scope.actionGameType = null
    $scope.successText = "Hyvää työtä!"

    $scope.endGameConfirm = false
    $scope.gameEnded = false
    $scope.showModal = true
    $scope.questionIndex = 0

    # fetch game information
    httpService.getGames(gameType).then (games) ->
      $scope.game = games.data[gameId-1]
      $scope.actionGameType = $scope.game.gameType
      if $scope.actionGameType is "audio"
        $rootScope.inGame = true
        mediaPath = $scope.game.media.toString()
        fullReplayPath = mediaPath.substring(0, mediaPath.length-4).concat("_gapless.mp3")
        $rootScope.sound = $scope.sound = ngAudio.load(fullReplayPath)
      if $scope.actionGameType is "video"
        $rootScope.inGame = true
        $scope.player = {
          videoId: $scope.game.videoUrl
          mediaContentUrl: "https://www.youtube.com/v/#{$scope.game.videoUrl}?version=3"
          width: '100%'
          height: $window.innerHeight-70 + "px"
        }

    # fetch questions and intro
    $scope.$watch "actionGameType", (actionGameType) ->

      if actionGameType
        setSuccessText(actionGameType)
        if actionGameType isnt "video"
          httpService.getGame(gameType, gameId).then (game) ->
            questions = game.data.questions
            $scope.currentQuestion = questions[$scope.questionIndex]

    $scope.$watch "sound.currentTime", (currentTime) ->
      if currentTime and $scope.currentQuestion
        currentTimeMS = currentTime*1000
        if $scope.currentQuestion.options and currentTimeMS > $scope.currentQuestion.options.changeAt
          $scope.questionIndex++
          $scope.currentQuestion = questions[$scope.questionIndex]
        if currentTime >= $scope.sound.duration
          $scope.currentQuestion.questionText = ""
          $scope.gameEnded = true

    stopAll = ->
      if $scope.sound
        $scope.sound.stop()

    $scope.setNextQuestion = ->
      $scope.questionIndex++
      if $scope.questionIndex < questions.length
        $scope.currentQuestion = questions[$scope.questionIndex]
      else
        $scope.gameEnded = true

    setSuccessText = (actionGameType) ->
      if actionGameType is "audio" and ($scope.gameId is 1 or $scope.gameId is 2)
        $scope.successText = "Miltä laulaminen tuntui tänään?"
      else if actionGameType is "images"
        $scope.successText = "Jumppaa myös musiikin mukana!"
      else if actionGameType is "video"
        $scope.successText = "Miten jumppa sujui tänään"
      else
        $scope.successText = "Hyvää työtä!"

    $scope.onReady = (event) ->
      $scope.ytPlayer = event.target

    $scope.onStateChange = (event) ->
     if event.data is 0
       $scope.gameEnded = true

    $scope.hideModal = ->
      $scope.showModal = false
      if $scope.actionGameType is "video" and $scope.ytPlayer
        $scope.ytPlayer.playVideo()

    $scope.quit = ->
      stopAll()
      $scope.endGameConfirm = false
      $rootScope.userConfirmedQuit = true
      $location.path "/games/#{gameType}"

    $scope.resume = ->
      $scope.endGameConfirm = false
      if $scope.actionGameType is "video"
        $scope.ytPlayer.playVideo()
      else
        $scope.sound.play()

    $rootScope.$on 'showConfirm', ->
      if $scope.actionGameType is "video"
        $scope.ytPlayer.pauseVideo()
      else
        $scope.sound.pause()
      $scope.endGameConfirm = true
