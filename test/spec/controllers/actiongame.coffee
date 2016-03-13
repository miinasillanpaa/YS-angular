'use strict'

describe 'Controller: ActiongameCtrl', ->

  # load the controller's module
  beforeEach module 'ysAngularApp'

  ActiongameCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ActiongameCtrl = $controller 'ActiongameCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(ActiongameCtrl.awesomeThings.length).toBe 3
