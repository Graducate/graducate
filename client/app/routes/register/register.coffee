'use strict'

angular.module 'graducateApp'
.config ($stateProvider) ->
  $stateProvider.state 'register',
    url: '/register'
    templateUrl: 'app/routes/register/register.html'
    controller: 'RegisterCtrl'
