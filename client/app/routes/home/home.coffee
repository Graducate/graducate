'use strict'

angular.module 'graducateApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.home',
    url: '/'
    templateUrl: 'app/routes/home/home.html'
    controller: 'HomeCtrl'
