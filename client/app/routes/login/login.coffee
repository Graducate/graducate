'use strict'

angular.module 'graducateApp'
.config ($stateProvider) ->
  $stateProvider.state 'login',
    url: '/login'
    templateUrl: 'app/routes/login/login.html'
    controller: 'LoginCtrl'
