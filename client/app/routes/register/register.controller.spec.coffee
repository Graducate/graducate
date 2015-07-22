'use strict'

describe 'Controller: RegisterCtrl', ->

  # load the controller's module
  beforeEach module 'graducateApp'
  RegisterCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    RegisterCtrl = $controller 'RegisterCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
