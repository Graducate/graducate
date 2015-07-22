'use strict'

angular.module 'graducateApp'
.controller 'ProfileCtrl', ($scope, $stateParams, User) ->
  User.getById $stateParams.userId
  .then (user) ->
    console.log user