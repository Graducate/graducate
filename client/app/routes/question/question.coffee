'use strict'

angular.module 'graducateApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.question',
    url: '/question/:questionId'
    templateUrl: 'app/routes/question/question.html'
    controller: 'QuestionCtrl'
