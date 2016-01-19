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
  'Upload'
  ($scope, _, $filter, $http, $base64, Upload) ->

    $scope.clientData = {
      firstName: 'Paul',
      lastName: 'Williams',
      address1: '327 S 87 St',
      email: 'test131ai@email.com'
      city: 'Omaha',
      state: 'NE',
      zipCode: '68123',
      vendorClientAccountId: 'ascaptest1314ai',
      taxEinTinSsn: '322-14-1396',
      tinType: 'ssn',
      phone: '207-515-1696',
      mobilePhone: '207-515-2997',
      bankName: 'TD Bank',
      bankAccountNumber: '12345678',
      bankRoutingNumber: '211274450',
      bankAccountType: 'checking',
      gender: 'male'
    }

    $scope.api = {
      # url: 'https://api.lyricfinancial.com/vendorAPI/v1/json/clients',
      # url: 'https://lyric-demo-server.herokuapp.com/clients/:vendorId/advance'
      url: 'http://server.dev:8082/clients/:vendorId/advance'
      vendorId: 'ascap',
      username: 'ascap',
      password: 'WxjXgrzzGzrkPMv7hBFJ@PMkQX9e3e2N',
      contentType: 'application/json'
      royaltyEarningsContentType: 'text/csv'
    }

    $scope.royaltyEarnings = {earnings: [
      { source: '', nameOnAccount: '', accountNumber: '', estimatedRoyalties: ''},
      { source: '', nameOnAccount: '', accountNumber: '', estimatedRoyalties: ''},
      { source: '', nameOnAccount: '', accountNumber: '', estimatedRoyalties: ''}
    ]}

    $scope.accountTypes = [{code: 'savings', description: 'Savings'},
                           {code: 'checking', description: 'Checking'}]


    $scope.countries = ['United States', 'Canada']

    $scope.submitted = false

    $scope.interacted = (field) ->
      $scope.submitted || field.$dirty

    $scope.submit = (registrationForm, royaltyEarningsFile)->

      $scope.submitted = true
      if !registrationForm.$valid
        return

      $scope.api.url = $scope.api.url.replace ':vendorId', $scope.clientData.vendorClientAccountId
      $scope.clientData.dob = $filter('date')(registrationForm.dob.$viewValue, 'yyyy-MM-dd')

      if registrationForm.royaltyEarningsFile?
        $scope.royaltyEarningsFile = registrationForm.royaltyEarningsFile.$viewValue
      confirm()

    $scope.saveForm = ->

      auth = $base64.encode($scope.api.username + ":" + $scope.api.password)
 
      if $scope.api.contentType == 'multipart/form-data'
        request = Upload.upload(
          url: $scope.api.url
          method: 'POST'
          headers: {
            # 'content-type': 'multipart/form-data; boundary=----WebKitFormBoundaryjaK20tBROpxBAbBT'
            'vendorId':'ascap'
            'Authorization': "Basic " + auth
          }
          fileName: 'royalties.csv'
          fileFormDataName: 'royaltyEarnings'
          data: {
            'royaltyEarnings': $scope.royaltyEarningsFile
            'clientData': JSON.stringify($scope.clientData)
          }
        )

      else
        if $scope.api.royaltyEarningsContentType == 'text/csv'
          $scope.clientData.royaltyEarnings = $base64.encode($scope.api.csvData)

        req =
          method: 'POST'
          url: $scope.api.url
          headers: {
            'content-type': 'application/json'
            'vendorId': $scope.api.vendorId
            'Authorization': "Basic " + auth
          }
          data: $scope.clientData

        request = $http(req)

      request
      .then (resp) ->
        advanceRequestComplete(resp.headers().access_token)
      .catch (error) ->
        advanceRequestError(error)

    document.addEventListener 'confirmationComplete', $scope.saveForm

    $scope.$on '$destroy', ->
      document.removeEventListener 'confirmationComplete', $scope.saveForm
])

