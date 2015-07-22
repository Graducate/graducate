'use strict'

angular.module 'graducateApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    templateUrl: 'app/routes/main.html'
    controller: 'MainCtrl'
