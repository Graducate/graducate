'use strict'

angular.module 'graducateApp'
.factory 'Question', ($http, $q) ->

  getAll: ->
    deferred = $q.defer()
    $http.get "api/questions"
    .success (questions) ->
      deferred.resolve questions
    .error (err) ->
      deferred.reject err

    deferred.promise

  get: (questionId) ->
    deferred = $q.defer()
    $http.get "api/questions/#{questionId}"
    .success (question) ->
      deferred.resolve question
    .error (err) ->
      deferred.reject err

    deferred.promise

  createAnswer: (questionId, answer) ->
    deferred = $q.defer()
    $http.post "api/questions/#{questionId}/answer", answer
    .success (answer) ->
      deferred.resolve answer
    .error (err) ->
      deferred.reject err

    deferred.promise

  createComment: (questionId, answerId, comment) ->
    deferred = $q.defer()
    $http.post "api/questions/#{questionId}/commentAnswer", {_id: answerId, comment: comment}
    .success (comment) ->
      deferred.resolve comment
    .error (err) ->
      deferred.reject err

    deferred.promise