'use strict'

describe 'Controller: PlaingameCtrl', ->

  # load the controller's module
  beforeEach module 'ysAngularApp'

  PlaingameCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PlaingameCtrl = $controller 'PlaingameCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(PlaingameCtrl.awesomeThings.length).toBe 3
