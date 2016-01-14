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
      zipCode: '68123',
      vendorClientAccountId: 'ascaptest1269'
    }

    $scope.server = { url:"https://lyric-demo-server.herokuapp.com"}

    $scope.royaltyEarnings = {earnings: [
      { source: '', nameOnAccount: '', accountNumber: '', estimatedRoyalties: ''},
      { source: '', nameOnAccount: '', accountNumber: '', estimatedRoyalties: ''},
      { source: '', nameOnAccount: '', accountNumber: '', estimatedRoyalties: ''}
    ]}

    $scope.postType = {type: "json"}

    $scope.requestAdvance = ->
 
      # if $scope.postType.type == 'form'
      #   Upload.upload(
      #     url: 'https://api.lyricfinancial.com/vendorAPI/v1/clients'
      #     file: $scope.royaltyEarningsFile
      #     method: 'POST'
      #     headers: 'content-type': 'multipart/form-data', 'vendorId':'ascap'
      #     fileName: 'doc.jpg'
      #     fileFormDataName: 'myFile'
      #     data: 'clientData': $scope.clientData
      #   )
      #   .then ->
      #     advanceRequestComplete(resp.headers.ACCESS_TOKEN)
      #   .catch ->
      #     advanceRequestError()

      #   return

      req =
        method: 'POST'
        url: $scope.server.url + '/clients/' + $scope.clientData.vendorClientAccountId + '/advance'
        headers: 'Content-Type': "application/json;"

      $http(req)
      .then (resp) ->
        advanceRequestComplete(resp.access_token)
      .catch ->
        advanceRequestError()

    document.addEventListener 'confirmationComplete', $scope.requestAdvance
])

