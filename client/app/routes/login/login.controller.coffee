'use strict'

angular.module 'graducateApp'
.controller 'LoginCtrl', ($scope, $state, Auth) ->
  $scope.login = ->
    Auth.login $scope.user
    .then (data) ->
      $state.go 'main.home'
