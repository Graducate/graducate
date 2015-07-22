'use strict'

angular.module 'graducateApp'
.factory 'User', ($resource, $q, $http) ->
  resource:
    $resource '/api/users/:id/:controller',
      id: '@_id'
    ,
      changePassword:
        method: 'PUT'
        params:
          controller: 'password'

      getMe:
        method: 'GET'
        params:
          id: 'me'
  getMe: ->
    deferred = $q.defer()
    $http.get "api/users/me"
    .success (user) ->
      deferred.resolve user
    .error (err) ->
      deferred.reject err

    deferred.promise

  getById: (userId) ->
    deferred = $q.defer()
    $http.get "api/users/#{userId}"
    .success (user) ->
      deferred.resolve user
    .error (err) ->
      deferred.reject err

    deferred.promise

  create: (user) ->
    deferred = $q.defer()
    $http.post "api/users", user
    .success (user) ->
      deferred.resolve user
    .error (err) ->
      deferred.reject err

    deferred.promise


