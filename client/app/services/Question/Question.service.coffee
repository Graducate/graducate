'use strict'

angular.module 'graducateApp'
.factory 'Question', ($http, $q) ->

  # Service logic
  # ...
  meaningOfLife = 42

  # Public API here
  someMethod: ->
    meaningOfLife

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
