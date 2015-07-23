'use strict'

describe 'Controller: AskQuestionCtrl', ->

  # load the controller's module
  beforeEach module 'graducateApp'
  AskQuestionCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AskQuestionCtrl = $controller 'AskQuestionCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
