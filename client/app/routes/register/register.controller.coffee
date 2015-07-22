'use strict'

angular.module 'graducateApp'
.controller 'RegisterCtrl', ($scope, $state, Auth) ->
  $scope.register = ->
    user =
      email: $scope.user.email
      password: $scope.user.password
      role: 'user'

    Auth.createUser user
    .then (user) ->
      Auth.login user
      .then ->
        $state.go 'main.home'