'use strict'

angular.module 'graducateApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'btford.socket-io',
  'ui.router'
]
.config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
  $urlRouterProvider
  .otherwise '/login'

  $locationProvider.html5Mode false
  $httpProvider.interceptors.push 'authInterceptor'

.factory 'authInterceptor', ($rootScope, $q, $cookieStore, $location) ->
  # Add authorization token to headers
  request: (config) ->
    config.headers = config.headers or {}
    config.headers.Authorization = 'Bearer ' + $cookieStore.get 'token' if $cookieStore.get 'token'
    config

  # Intercept 401s and redirect you to login
  responseError: (response) ->
    if response.status is 401
      $location.path '/login'
      # remove any stale tokens
      $cookieStore.remove 'token'

    $q.reject response

.run ($rootScope, $location, Auth, $state) ->
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$stateChangeStart', (event, next, params) ->
    Auth.isLoggedInAsync (loggedIn) ->
      if loggedIn && next.name is "login"
        event.preventDefault()
        $state.go "main.home"
      else if ~next.name.indexOf("main") and not loggedIn
        event.preventDefault()
        newParams =
          toState: JSON.stringify next.name
          toParams: JSON.stringify params
        $state.go "login", newParams
