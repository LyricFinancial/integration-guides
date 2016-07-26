angular.module( 'lyricvendordemo.demo-server', [
  'ui.router'
  'ui.bootstrap'
  'ngFileUpload'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'demo-server',
      url: '/demo-server?:strategy&:vendorClientAccountId',
      views:
        "main":
          controller: 'DemoServerCtrl',
          templateUrl: 'demo-server/demo-server.tpl.html'
      resolve:
        clientData: [
          () ->
            return {
              firstName: 'Paul',
              lastName: 'Williams',
              address1: '327 S 87 St',
              city: 'Omaha',
              state: 'NE',
              zipCode: '68123'
            }
        ]

    data:{ pageTitle: 'Lyric Vendor Demo' }
])


.controller( 'DemoServerCtrl', [
  '$scope'
  '$state'
  '_'
  '$filter'
  '$http'
  'clientData'
  'ENV'
  '$stateParams'
  ($scope, $state, _, $filter, $http, clientData, ENV, $stateParams) ->
    strategy = 'syncManualRedirect'

    if $stateParams.strategy?
      strategy = $stateParams.strategy

    terms = "Custom Terms & Conditions"
    $scope.clientData = clientData
    vendorClientAccountId = ''

    if strategy == 'async'
      vendorClientAccountId = $stateParams.vendorClientAccountId
      $scope.asyncToken = null

      req =
        method: 'GET'
        url: ENV.DEMO_SERVER_URL + '/asynctoken?vendorClientAccountId=' + vendorClientAccountId
        headers: 'Content-Type': "application/json"

      $http(req)
      .then (resp) ->
        $scope.asyncToken = resp.headers().token
        $scope.lyric = new LyricSnippet(terms, strategy, $scope.asyncToken, ENV.VATM_URL)
      .catch (error)->
    else
      $scope.lyric = new LyricSnippet(terms, strategy, null, ENV.VATM_URL)
    

    $scope.server = {
      url: ENV.DEMO_SERVER_URL + "/clients/:vendorClntAcctId/advance_server"
      vendorClientAccountId: vendorClientAccountId
      sslOverride: false
      joseOverride: false
    }

    $scope.options = {
      contentType: "application/json"
      royaltyEarningsContentType: "text/csv"
      filename: ""
    }

    $scope.requestAdvance = ->

      url = $scope.server.url.replace ':vendorClntAcctId', $scope.server.vendorClientAccountId

      params = []

      if $scope.server.authToken? && $scope.server.vendorId?
        params.push 'authToken=' + $scope.server.authToken
        params.push 'vendor-id=' + $scope.server.vendorId

      if $scope.server.securityJoseOverride == true
        params.push 'ssl=' + $scope.server.sslOverride
        params.push 'jose=' + $scope.server.joseOverride

      if params.length > 0
        url += '?' + params.join('&')

      req =
        method: 'POST'
        url: url
        headers: { 'Content-Type': "application/json", 'async-token' : $scope.asyncToken }
        data: {options: $scope.options}

      $http(req)
      .then (resp) ->
        if strategy == 'async'
          return

        $scope.lyric.advanceRequestComplete(resp.headers()["access-token"])
      .catch (error)->
        $scope.lyric.advanceRequestError(error)

    document.addEventListener 'confirmationComplete', $scope.requestAdvance

    $scope.$on '$destroy', ->
      document.removeEventListener 'confirmationComplete', $scope.requestAdvance
])

