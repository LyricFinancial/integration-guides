angular.module( 'sonydemo.login', [
  'ui.router'
  'userRepository'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'login',
      url: '/login',
      views:
        "main":
          controller: 'LoginCtrl',
          templateUrl: 'login/login.tpl.html'
    data:{ pageTitle: 'Sony Demo' }

])


.controller( 'LoginCtrl', [
  '$scope'
  '$state'
  ($scope, $state) ->
    $scope.loginObject = {
      showPin: false,
      username: null,
      password: null
    }

    $scope.goToPin = () ->
      if($scope.loginObject.username == null || $scope.loginObject.password == null)
        return

      $scope.loginObject.showPin = true

    $scope.login = ()->
      $state.go 'statements', vendorClientAccountId: $scope.loginObject.username
])

