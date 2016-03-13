'use strict'

describe 'Controller: HeaderCtrl', ->

  # load the controller's module
  beforeEach module 'ysAngularApp'

  HeaderCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    HeaderCtrl = $controller 'HeaderCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(HeaderCtrl.awesomeThings.length).toBe 3
