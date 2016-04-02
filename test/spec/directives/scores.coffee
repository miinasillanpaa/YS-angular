'use strict'

describe 'Directive: scores', ->

  # load the directive's module
  beforeEach module 'ysAngularApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<scores></scores>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the scores directive'
