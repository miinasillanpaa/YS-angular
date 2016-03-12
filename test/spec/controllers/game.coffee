'use strict'

describe 'Controller: GameCtrl', ->

  # load the controller's module
  beforeEach module 'ysAngularApp'

  GameCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    GameCtrl = $controller 'GameCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(GameCtrl.awesomeThings.length).toBe 3
