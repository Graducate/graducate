'use strict'

angular.module 'graducateApp'
.controller 'QuestionCtrl', ($scope, $stateParams, Question, Auth) ->
  Question.get $stateParams.questionId
  .then (question) ->
    $scope.question = question
    console.log question

  $scope.answer = ->
    answer =
      body: $scope.answer.body
      comments: []
      creator: Auth.getCurrentUser()

    Question.createAnswer $scope.question._id, answer
    .then (answer) ->
      $scope.answer.body = ''
      $scope.question.answers.push answer

  $scope.comment = (answer) ->
    comment =
      body: answer.newComment.body
      creator: Auth.getCurrentUser()

    Question.createComment $scope.question._id, answer._id, comment
    .then (comment) ->
      answer.newComment.body = ''
      answer.comments.push comment