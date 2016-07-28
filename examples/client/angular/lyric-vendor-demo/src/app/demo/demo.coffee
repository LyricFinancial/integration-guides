angular.module( 'lyricvendordemo.demo', [
  'ui.router'
  'ui.bootstrap'
  'ngFileUpload'
  'angular-json-editor'
  'commonLyricServices'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'demo',
      url: '/demo?:strategy&:vendorClientAccountId',
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
  'ENV'
  '$stateParams'
  'CommonLyricServices'
  ($scope, _, $filter, $http, $base64, Upload, ENV, $stateParams, common) ->

    vendorClientAccountId = $stateParams.vendorClientAccountId

    common.setupLyricSnippet(vendorClientAccountId, 'Demo', ENV.VATM_URL)
    .then (lyric) ->
      $scope.lyric = lyric

    $scope.clientData = { userProfile: {
      user: {
        firstName: 'Paul',
        lastName: 'Williams',
        email: ''
      },
      vendorAccount: {
        vendorClientAccountId: vendorClientAccountId
      },
      taxInfo: {
        taxEinTinSsn: '',
        tinType: 'ssn',
        memberBusinessType: 'individual'
      }
      
    }}

    $scope.api = {
      url: ENV.DEMO_SERVER_URL + "/clients/:vendorClntAcctId/advance_client"
      contentType: 'application/json'
      royaltyEarningsContentType: 'text/csv'
      sslOverride: false
      joseOverride: false
    }

    $scope.genders = [{code: 'male', description: 'Male'},
                     {code: 'female', description: 'Female'}]

    $scope.maritalStatuses = [{code: 'single', description: 'Single'},
                              {code: 'married', description: 'Married'},
                              {code: 'separated', description: 'Separated'},
                              {code: 'divorced', description: 'Divorced'},
                              {code: 'widowed', description: 'Widowed'}]

    

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

      if $scope.clientData.userProfile.user.dob?
        $scope.clientData.userProfile.user.dob = $filter('date')(registrationForm.dob.$viewValue, 'yyyy-MM-dd')

      if registrationForm.royaltyEarningsFile?
        $scope.royaltyEarningsFile = registrationForm.royaltyEarningsFile.$viewValue
      $scope.lyric.confirm()

    $scope.saveForm = ->

      url = $scope.api.url.replace ':vendorClntAcctId', $scope.clientData.userProfile.vendorAccount.vendorClientAccountId
      
      params = []

      if $scope.api.authToken? && $scope.api.vendorId?
        params.push 'authToken=' + $scope.api.authToken
        params.push 'vendor-id=' + $scope.api.vendorId

      if $scope.api.securityJoseOverride == true
        params.push 'ssl=' + $scope.api.sslOverride
        params.push 'jose=' + $scope.api.joseOverride

      if params.length > 0
        url += '?' + params.join('&')
 
      if $scope.clientData.userProfile.taxInfo? && $scope.isBlank($scope.clientData.userProfile.taxInfo.taxEinTinSsn)
        delete $scope.clientData.userProfile.taxInfo

      if $scope.api.contentType == 'multipart/form-data'
        request = Upload.upload(
          url: url
          method: 'POST'
          fileName: 'royalties.csv'
          fileFormDataName: 'royaltyEarnings'
          data: {
            'royaltyEarnings': $scope.royaltyEarningsFile
            'clientData': JSON.stringify($scope.clientData)
          }
        )

      else
        # if $scope.api.royaltyEarningsContentType == 'text/csv'
        #   $scope.clientData.royaltyEarnings = $base64.encode($scope.api.csvData)

        headers = {
          'content-type': 'application/json'
        }

        if $stateParams.strategy == 'async'
          headers = {
            'content-type': 'application/json',
            'async-token': common.asyncToken
          }

        req =
          method: 'POST'
          url: url
          headers: headers
          data: $scope.clientData

        request = $http(req)

      request
      .then (resp) ->
        if $stateParams.strategy == 'async'
          return
        $scope.lyric.advanceRequestComplete(resp.headers()["access-token"])
      .catch (error) ->
        $scope.lyric.advanceRequestError(error)

    document.addEventListener 'confirmationComplete', $scope.saveForm

    $scope.$on '$destroy', ->
      document.removeEventListener 'confirmationComplete', $scope.saveForm

    $scope.isBlank = (str) ->
      return (!str || /^\s*$/.test(str))

    #$scope.myStartVal = age: 20, name: 'Amy Madden'
    $scope.myStartVal = {royaltyEarnings: [
      {
        source: '',
        accountNumber: '',
        nameOnAccount: '',
        year: '',
        quarter: '',
        string1: '',
        distributionDate: '',
        estimatedRoyalties: ''
      }
    ]}

    $scope.onChange = (data) ->
      $scope.royaltyEarnings = data

    $scope.mySchema = $http.get('assets/royaltyEarningsSchema.json')
])

