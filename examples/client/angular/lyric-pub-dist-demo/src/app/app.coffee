angular.module( 'lyricdemo', [
  'config'
  'templates-app',
  'templates-common'
  'lyricdemo.publisher'
  'lyricdemo.distributor'
  'lyricdemo.assignments'
  'ui.router'
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

  ($stateProvider, $urlRouterProvider, $httpProvider) ->
    $urlRouterProvider.otherwise( '/publisher' )
])

.controller( 'AppCtrl', [
  '$scope'
  '$state'
  ($scope, $state) ->

    $scope.isAuthenticated = ->
      return $state.current.name != 'login'

    $scope.isAssignments = ->
      return $state.current.name == 'assignments'

])