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
    data:{ pageTitle: 'Lyric Vendor Demo' }

])


.controller( 'DemoServerCtrl', [
  '$scope'
  '$state'
  '_'
  '$filter'
  '$http'
  ($scope, $state, _, $filter, $http) ->

    $scope.clientData = {
      firstName: 'Paul',
      lastName: 'Williams',
      address1: '327 S 87 St',
      city: 'Omaha',
      state: 'NE',
      zipCode: '68123'
    }

    $scope.server = { url:"https://lyric-demo-server.herokuapp.com/clients/ascaptest123/advance"}

    $scope.options = {
      contentType: "application/json"
      jsonRoyaltyEarningsContentType: "text/csv"
      multipartRoyaltyEarningsContentType: "text/csv"
    }

    $scope.requestAdvance = ->

      req =
        method: 'POST'
        url: $scope.server.url
        headers: 'Content-Type': "application/json;"
        data: $scope.options

      $http(req)
      .then (resp) ->
        advanceRequestComplete(resp.access_token)
      .catch ->
        advanceRequestError()

    document.addEventListener 'confirmationComplete', $scope.requestAdvance
])

