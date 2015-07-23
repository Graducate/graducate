'use strict'

angular.module 'graducateApp'
.controller 'LoginCtrl', ($scope, $state, $animate, Auth) ->
  $scope.login = ->
    Auth.login $scope.user
    .then (data) ->
      $state.go 'main.home'
    .catch (err) ->
      element = $('#login-form')
      $animate.addClass element, 'animated shake'
