angular.module( 'lyricdemo', [
  'config'
  'templates-app',
  'templates-common'
  'lyricdemo.login'
  'lyricdemo.publisher'
  'lyricdemo.distributor'
  'lyricdemo.assignments'
  'ui.router'
  'satellizer'
  'auth0.lock'
])

.factory '_', ->
  return window._

.filter 'capitalize', ->
  (input) ->
    if ! !input then input.charAt(0).toUpperCase() + input.substr(1).toLowerCase() else ''

.filter('sonydate', [
  '$filter'
  
  ($filter) ->
    (input) ->
      date = new Date(input)
      input = $filter('date')(date, 'MMM yyyy')
])

.config([
  '$stateProvider'
  '$urlRouterProvider'
  '$httpProvider'
  'lockProvider'
  ($stateProvider, $urlRouterProvider, $httpProvider, lockProvider) ->
    $urlRouterProvider.otherwise( '/publisher' )

    lockProvider.init
      clientID: 'mXBdeZrKlRYX0TvSRu4nhphUaRQ35Y7z'
      domain: 'lyricfinancial.auth0.com'
      options:
        _idTokenVerification: false
        autofocus: true
        closable: false
])

.run([
  'lock'
  '$state'
  '$auth'
  (lock, $state, $auth) ->
    lock.interceptHash()
    lock.on 'authenticated', (authResult) ->
      $auth.setToken(authResult.idToken)
      $state.go 'publisher'
])

.controller( 'AppCtrl', [
  '$scope'
  '$state'
  '$auth'
  ($scope, $state, $auth) ->

    $scope.isAuthenticated = ->
      return $state.current.name != 'login'

    $scope.isAssignments = ->
      return $state.current.name == 'assignments'

    $scope.logout = ->
      $auth.logout()
      $state.go 'login'

])