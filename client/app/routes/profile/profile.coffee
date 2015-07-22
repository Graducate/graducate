'use strict'

angular.module 'graducateApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.profile',
    url: '/profile/:userId'
    templateUrl: 'app/routes/profile/profile.html'
    controller: 'ProfileCtrl'
