'use strict'

angular.module 'graducateApp'
.controller 'MainCtrl', ($scope, $http, $state, socket, Question, Auth, User) ->
  $scope.awesomeThings = []

  $scope.user = Auth.getCurrentUser()

  $scope.logout = ->
    Auth.logout()
    $state.go 'login'
