'use strict'

angular.module 'graducateApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.about',
    url: '/about'
    templateUrl: 'app/routes/about/about.html'
    controller: 'AboutCtrl'
