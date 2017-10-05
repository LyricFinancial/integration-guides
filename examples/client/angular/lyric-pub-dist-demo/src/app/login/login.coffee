angular.module( 'lyricdemo.login', [
  'ui.router'
  'ngSanitize'
  'commonLyricServices'
  'sharedDataService'
  'ngCookies'
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
      resolve:
        authenticate: [
          '$auth'
          '$q'
          '$state'
          '$timeout'
          ($auth, $q, $state, $timeout) ->
            defer = $q.defer()

            $timeout ->
              if !$auth.isAuthenticated()
                defer.resolve()
                return

              $state.go 'publisher'
              defer.reject()

            return defer.promise
        ]
    data:{ pageTitle: 'Lyric Demo' }

])

.controller( 'LoginCtrl', [
  '$scope'
  'lock'
  '$auth'
  ($scope, lock, $auth) ->
    $scope.isAuthenticated = $auth.isAuthenticated()
    
    options = {
      allowSignUp: false
      iconUrl: '../assets/login-logo.png'
      allowedConnections: ['LyricAdmin']
      rememberLastLogin: true
    }

    lock.show(options)
])

