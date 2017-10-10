angular.module( 'lyricdemo', [
  'config'
  'angular-jwt'
  'templates-app',
  'templates-common'
  'lyricdemo.login'
  'lyricdemo.publisher'
  'lyricdemo.distributor'
  'lyricdemo.assignments'
  'ui.router'
  'satellizer'
  'auth0.lock'
  'ngMaterial'
  'picardy.fontawesome'
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
      date = new Date(input.split(" ")[0])
      input = $filter('date')(date, 'MMM yyyy')
])

.config([
  '$stateProvider'
  '$urlRouterProvider'
  '$httpProvider'
  'lockProvider'
  '$authProvider'
  ($stateProvider, $urlRouterProvider, $httpProvider, lockProvider, $authProvider) ->
    $urlRouterProvider.otherwise( '/publisher' )

    $authProvider.storageType = 'sessionStorage'

    lockProvider.init
      clientID: 'mXBdeZrKlRYX0TvSRu4nhphUaRQ35Y7z'
      domain: 'lyricfinancial.auth0.com'
      options:
        _idTokenVerification: false
        container: 'login-container'
        languageDictionary:
          title: ""
        theme:
          logo: '../assets/images/logo-red.png'
        autofocus: true
        closable: false
        auth:
          redirect: false
          sso: false
          params:
            scope: 'openid email'
])

.run([
  'lock'
  '$state'
  '$auth'
  '$cookies'
  'jwtHelper'
  (lock, $state, $auth, $cookies, jwtHelper) ->
    lock.interceptHash()
    lock.on 'authenticated', (authResult, profile) ->
      lock.hide()
      $auth.setToken(authResult.idToken)

      decodedResult = jwtHelper.decodeToken(authResult.idToken)

      if decodedResult.email == 'jump-ball@example.com'
        $state.go 'distributor', {vendorClientAccountId: 'jb123456'}
        return
      else if decodedResult.email == 'ez-tunes@example.com'
        $state.go 'distributor', {vendorClientAccountId: 'ezt123456'}
        return

      state = 'publisher'
      params = {vendorClientAccountId: '119005',masterClientId: '23896'}
      previousState = $cookies.get('previousState')

      if previousState?
        previousStateJson = JSON.parse(previousState)

        state = previousStateJson.state
        params = previousStateJson.params[state]

      $state.go state, params
])

.controller( 'AppCtrl', [
  '$scope'
  '$state'
  '$auth'
  '$cookies'
  ($scope, $state, $auth, $cookies) ->

    $scope.$state = $state

    $scope.logout = ->
      $auth.logout()
      $state.go 'login'

    $scope.switchVendorType = (vendorType)->
      previousState = JSON.parse($cookies.get('previousState'))
      vendorTypeParams = previousState.params[vendorType]

      $state.go vendorType, vendorTypeParams

    $scope.setPreviousState = (vendorType, vendorClientAccountId, masterClientId) ->
      previousState = $cookies.get('previousState')

      if previousState?
        previousStateJson = JSON.parse(previousState)
      else
        previousStateJson = {params: {distributor: {vendorClientAccountId: 'eliLyricTest'}, publisher: {}}}

      previousStateJson.state = vendorType
      previousStateJson.params[vendorType].vendorClientAccountId = vendorClientAccountId

      if masterClientId?
        previousStateJson.params[vendorType].masterClientId = masterClientId
      else
        previousStateJson.params[vendorType].masterClientId = null

      $cookies.put('previousState', JSON.stringify(previousStateJson))

])