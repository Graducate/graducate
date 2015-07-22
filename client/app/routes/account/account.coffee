'use strict'

angular.module 'graducateApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.account',
    url: '/account'
    templateUrl: 'app/routes/account/account.html'
    controller: 'AccountCtrl'
