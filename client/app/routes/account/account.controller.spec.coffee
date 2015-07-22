'use strict'

describe 'Controller: AccountCtrl', ->

  # load the controller's module
  beforeEach module 'graducateApp'
  AccountCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AccountCtrl = $controller 'AccountCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
