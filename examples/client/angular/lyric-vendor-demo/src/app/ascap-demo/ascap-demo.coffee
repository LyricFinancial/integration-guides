angular.module( 'lyricvendordemo.ascap-demo', [
  'ui.router'
  'ui.bootstrap'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'ascap-demo',
      url: '/ascap-demo',
      views:
        "main":
          controller: 'AscapDemoCtrl',
          templateUrl: 'ascap-demo/ascap-demo.tpl.html'
    data:{ pageTitle: 'ASCAP Demo' }

])


.controller( 'AscapDemoCtrl', [
  '$scope'
  '_'
  '$filter'
  '$http'
  'ENV'
  ($scope, _, $filter, $http, ENV) ->

    $scope.lyric = new LyricSnippet("Custom Terms & Conditions", ENV.VATM_URL)

    $scope.user = {
      address1: '2 MUSIC CIRCLE SOUTH',
      address2: 'SUITE 212',
      city: 'NASHVILE',
      state: 'TN',
      countryCode: 'US',
      zipCode: '37212',
      phoneNumber: '(615) 736 9823',
      emailAddress: 'eli@lyricfinancial.com',
      status: 'Current',
      paymentMethod: 'Direct Deposit'
    }

    $scope.options = {
      contentType: "application/json"
      royaltyEarningsContentType: "text/csv"
      filename: ""
    }

    $scope.requestAdvance = ->

      #url = $scope.server.url.replace ':vendorClntAcctId', $scope.server.vendorClientAccountId

      url = ENV.DEMO_SERVER_URL + "/clients/bmiTest432/advance_server"
      url = url + '?username=ascap&password=WxjXgrzzGzrkPMv7hBFJ@PMkQX9e3e2N&vendorId=ascap'

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

