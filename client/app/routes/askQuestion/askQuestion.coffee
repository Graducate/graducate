'use strict'

angular.module 'graducateApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.askQuestion',
    url: '/ask-question'
    templateUrl: 'app/routes/askQuestion/askQuestion.html'
    controller: 'AskQuestionCtrl'
