'use strict'

describe 'Controller: GametypeCtrl', ->

  # load the controller's module
  beforeEach module 'ysAngularApp'

  GametypeCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    GametypeCtrl = $controller 'GametypeCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(GametypeCtrl.awesomeThings.length).toBe 3
