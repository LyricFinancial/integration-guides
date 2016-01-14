angular.module( 'lyricvendordemo.demo', [
  'ui.router'
  'ui.bootstrap'
  'ngFileUpload'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'demo',
      url: '/demo',
      views:
        "main":
          controller: 'DemoCtrl',
          templateUrl: 'demo/demo.tpl.html'
    data:{ pageTitle: 'Lyric Vendor Demo' }

])


.controller( 'DemoCtrl', [
  '$scope'
  '_'
  '$filter'
  '$http'
  '$base64'
  ($scope, _, $filter, $http, $base64) ->

    $scope.clientData = {
      firstName: 'Paul',
      lastName: 'Williams',
      address1: '327 S 87 St',
      email: 'test52@email.com'
      city: 'Omaha',
      state: 'NE',
      zipCode: '68123',
      vendorClientAccountId: 'ascaptest1269',
      ssn: '333-44-5547',
      phone: '2075554448',
      mobilePhone: '2075556648',
      bankName: 'TD Bank',
      bankAccountNumber: '12345678',
      bankRoutingNumber: '211274450',
      bankAccountType: 'checking'
    }

    $scope.server = { url:"https://lyric-demo-server.herokuapp.com"}

    $scope.royaltyEarnings = {earnings: [
      { source: '', nameOnAccount: '', accountNumber: '', estimatedRoyalties: ''},
      { source: '', nameOnAccount: '', accountNumber: '', estimatedRoyalties: ''},
      { source: '', nameOnAccount: '', accountNumber: '', estimatedRoyalties: ''}
    ]}

    $scope.postType = {type: "json"}

    $scope.accountTypes = [{code: 'savings', description: 'Savings'},
                           {code: 'checking', description: 'Checking'}]


    $scope.countries = ['United States', 'Canada']

    $scope.submitted = false

    $scope.interacted = (field) ->
      $scope.submitted || field.$dirty

    $scope.submit = (registrationForm, dob, royaltyEarningsFile, serverUrl)->

      $scope.submitted = true
      if !registrationForm.$valid
        return

      $scope.clientData.dob = $filter('date')(dob, 'yyyy-MM-dd')

      confirm()

    $scope.saveForm = ->
 
      if $scope.postType.type == 'form'
        Upload.upload(
          url: 'https://api.lyricfinancial.com/vendorAPI/v1/clients'
          file: $scope.royaltyEarningsFile
          method: 'POST'
          headers: 'content-type': 'multipart/form-data', 'vendorId':'ascap'
          fileName: 'doc.jpg'
          fileFormDataName: 'myFile'
          data: 'clientData': $scope.clientData
        )
        .then ->
          advanceRequestComplete(resp.headers.ACCESS_TOKEN)
        .catch ->
          advanceRequestError()

        return

      auth = $base64.encode("ascap:WxjXgrzzGzrkPMv7hBFJ@PMkQX9e3e2N")

      req =
        method: 'POST'
        url: 'https://api.lyricfinancial.com/vendorAPI/v1/json/clients'
        headers: {
          'Content-Type': 'application/json;'
          'vendorId': 'ascap'
          'Authorization': "Basic " + auth
        }
        data: $scope.clientData

      $http(req)
      .then (resp) ->
        advanceRequestComplete(resp.access_token)
      .catch ->
        advanceRequestError()

    document.addEventListener 'confirmationComplete', $scope.saveForm
])

