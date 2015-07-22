'use strict'

angular.module 'graducateApp'
.controller 'HomeCtrl', ($scope, Question) ->

  Question.getAll()
  .then (questions) ->
    $scope.questions = questions