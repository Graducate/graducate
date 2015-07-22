'use strict'

angular.module 'graducateApp'
.controller 'QuestionCtrl', ($scope, $stateParams, Question) ->
  Question.get $stateParams.questionId
  .then (question) ->
    $scope.question = question
    console.log question