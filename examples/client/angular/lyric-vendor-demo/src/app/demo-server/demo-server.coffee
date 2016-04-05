angular.module( 'lyricvendordemo.demo-server', [
  'ui.router'
  'ui.bootstrap'
  'ngFileUpload'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'demo-server',
      url: '/demo-server',
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
  ($scope, $state, _, $filter, $http, clientData, ENV) ->
    $scope.lyric = new LyricSnippet("Custom Terms & Conditions", ENV.VATM_URL)

    $scope.clientData = clientData

    $scope.server = {
      url: ENV.DEMO_SERVER_URL + "/clients/:vendorClntAcctId/advance_server",
      vendorClientAccountId: ''
    }

    $scope.options = {
      contentType: "application/json"
      royaltyEarningsContentType: "text/csv"
      filename: ""
    }

    $scope.requestAdvance = ->

      url = $scope.server.url.replace ':vendorClntAcctId', $scope.server.vendorClientAccountId

      if $scope.server.authToken? && $scope.server.vendorId?
        url = url + '?authToken=' + $scope.server.authToken + '&vendorId=' + $scope.server.vendorId

      req =
        method: 'POST'
        url: url
        headers: 'Content-Type': "application/json"
        data: {options: $scope.options}

      $http(req)
      .then (resp) ->
        $scope.lyric.advanceRequestComplete(resp.headers().access_token)
      .catch (error)->
        $scope.lyric.advanceRequestError(error)

    document.addEventListener 'confirmationComplete', $scope.requestAdvance

    $scope.$on '$destroy', ->
      document.removeEventListener 'confirmationComplete', $scope.requestAdvance
])

