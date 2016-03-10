angular.module( 'sonydemo', [
  'config'
  'templates-app',
  'templates-common'
  'sonydemo.login'
  'sonydemo.client_payee'
  'sonydemo.statements'
  'sonydemo.assignments'
  'ui.router'
])

.config([
  '$stateProvider'
  '$urlRouterProvider'
  '$httpProvider'

  ($stateProvider, $urlRouterProvider, $httpProvider) ->
    $urlRouterProvider.otherwise( '/login' )
])

.controller( 'AppCtrl', [
  '$scope'
  '$state'
  'UserRepository'
  ($scope, $state, userRepo) ->

    $scope.userRepo = userRepo

    $scope.isAuthenticated = ->
      return $state.current.name != 'login'

    $scope.isAssignments = ->
      return $state.current.name == 'assignments'

])