'use strict'

describe 'Service: Question', ->

  # load the service's module
  beforeEach module 'graducateApp'

  # instantiate service
  Question = undefined
  beforeEach inject (_Question_) ->
    Question = _Question_

  it 'should do something', ->
    expect(!!Question).toBe true