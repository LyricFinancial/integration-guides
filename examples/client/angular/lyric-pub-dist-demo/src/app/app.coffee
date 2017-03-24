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
  'ngMaterial'
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
        autofocus: true
        closable: false
        auth:
          redirect: false
          #sso: false
])

.run([
  'lock'
  '$state'
  '$auth'
  '$cookies'
  (lock, $state, $auth, $cookies) ->
    lock.interceptHash()
    lock.on 'authenticated', (authResult) ->
      lock.hide()
      $auth.setToken(authResult.idToken)
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