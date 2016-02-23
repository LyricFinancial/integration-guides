angular.module( 'lyricvendordemo.bmi-demo', [
  'ui.router'
  'ui.bootstrap'
  'userRepository'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'bmi-demo',
      url: '/bmi-demo?:vendorClientAccountId',
      views:
        "main":
          controller: 'BmiDemoCtrl',
          templateUrl: 'bmi-demo/bmi-demo.tpl.html'
      resolve:
        clientData: [
          'UserRepository'
          '$stateParams'
          (userRepo, $stateParams) ->
            vendorClientAccountId = $stateParams.vendorClientAccountId
            return userRepo.lookupUser(vendorClientAccountId)
        ]
    data:{ pageTitle: 'ASCAP Demo' }

])


.controller( 'BmiDemoCtrl', [
  '$scope'
  '_'
  '$filter'
  '$http'
  'ENV'
  'clientData'
  ($scope, _, $filter, $http, ENV, clientData) ->

    $scope.lyric = new LyricSnippet("Custom Terms & Conditions", "https://integrationservices.lyricfinancial.com")
    $scope.clientData = clientData

    $scope.options = {
      contentType: "application/json"
      royaltyEarningsContentType: "text/csv"
      filename: ""
    }

    $scope.requestAdvance = ->
      url = ENV.BMI_DEMO_SERVER_URL + '/clients/' + $scope.clientData.vendorAccount.vendorClientAccountId + '/advance_client'

      req =
        method: 'POST'
        url: url
        headers: 'Content-Type': "application/json"
        data: clientData

      $http(req)
      .then (resp) ->
        $scope.lyric.advanceRequestComplete(resp.headers().access_token)
      .catch (error)->
        $scope.lyric.advanceRequestError(error)

    document.addEventListener 'confirmationComplete', $scope.requestAdvance

    $scope.$on '$destroy', ->
      document.removeEventListener 'confirmationComplete', $scope.requestAdvance
])

