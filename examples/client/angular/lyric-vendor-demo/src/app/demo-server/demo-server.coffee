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
    $scope.lyric = new LyricSnippet("Custom Terms & Conditions")


    $scope.clientData = {
      firstName: 'Paul',
      lastName: 'Williams',
      address1: '327 S 87 St',
      city: 'Omaha',
      state: 'NE',
      zipCode: '68123'
    }

    $scope.server = {
      url:"https://lyric-demo-server.herokuapp.com/clients/:vendorClntAcctId/advance_server",
      vendorClientAccountId: ''
    }

    $scope.options = {
      contentType: "application/json"
      royaltyEarningsContentType: "text/csv"
      filename: ""
    }

    $scope.requestAdvance = ->

      url = $scope.server.url.replace ':vendorClntAcctId', $scope.server.vendorClientAccountId

      if $scope.server.username? && $scope.server.password? && $scope.server.vendorId?
        url = url + '?username=' + $scope.server.username + '&password=' + $scope.server.password + '&vendorId=' + $scope.server.vendorId
      


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
