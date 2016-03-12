'use strict'

describe 'Service: httpService', ->

  # load the service's module
  beforeEach module 'ysAngularApp'

  # instantiate service
  httpService = {}
  beforeEach inject (_httpService_) ->
    httpService = _httpService_

  it 'should do something', ->
    expect(!!httpService).toBe true
