angular.module( 'lyricdemo.distributor', [
  'ui.router'
  'ngSanitize'
  'commonLyricServices'
  'sharedDataService'
  'ngCookies'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'distributor',
      url: '/distributor?vendorClientAccountId&:masterClientId&:strategy&:showOptions',
      views:
        "main":
          controller: 'DistributorCtrl',
          templateUrl: 'distributor/distributor.tpl.html'
      resolve:
        authenticate: [
          '$auth'
          '$q'
          '$state'
          '$timeout'
          ($auth, $q, $state, $timeout) ->
            defer = $q.defer()

            $timeout ->
              if $auth.isAuthenticated()
                defer.resolve()
                return

              $state.go 'login'
              defer.reject()

            return defer.promise
        ]
        init: [
          'authenticate'
          '$stateParams'
          '$state'
          '$q'
          'SharedDataService'
          (authenticate, $stateParams, $state, $q, data) ->
            defer = $q.defer()

            vendorClientAccountId = $stateParams.vendorClientAccountId
            masterClientId = $stateParams.masterClientId

            data.setClientData(vendorClientAccountId, masterClientId)

            defer.resolve()

            return defer.promise
        ]
    data:{ pageTitle: 'Lyric Demo' }

])

.controller( 'DistributorCtrl', [
  '$scope'
  '$http'
  'ENV'
  '$stateParams'
  'CommonLyricServices'
  'SharedDataService'
  '_'
  '$cookies'
  '$auth'
  ($scope, $http, ENV, $stateParams, common, data, _, $cookies, $auth) ->
    $scope.isAuthenticated = $auth.isAuthenticated()
    vendorId = "demodistributor"
    $scope.vendorType = 'distributor'
    vendorClientAccountId = $stateParams.vendorClientAccountId
    masterClientId = $stateParams.masterClientId
    $scope.showOptions = $stateParams.showOptions

    $scope.setPreviousState($scope.vendorType, vendorClientAccountId, masterClientId)

    $scope.data = data
    if data.clientData == null
      alert('no user record')

    $scope.fileOptions = data.getFileDataOptions('distributorFileOptions', data.distributorDefaultFileOptions)

    $scope.$watchGroup ['fileOptions.frequencyInDays', 'fileOptions.numberOfPeriods', 'fileOptions.numberOfRecordsPerPeriod'], (newValue, oldValue) ->
      $scope.reloadFileRecords()

    $scope.reloadFileRecords = ->
      $cookies.put('distributorFileOptions', JSON.stringify($scope.fileOptions))
      data.getFileRecords(vendorClientAccountId, $scope.fileOptions)
      .then ->
        sortedFileRecords = _.sortBy(data.fileRecords, (fileRecord) ->
          return fileRecord.salesPeriod
        ).reverse()
        $scope.fileRecords = _(sortedFileRecords).first 15

        firstRecord = _(sortedFileRecords).first()
        lastRecord = _(sortedFileRecords).last()

        $scope.firstRecordDate = new Date(firstRecord.salesPeriod)
        $scope.lastRecordDate = new Date(lastRecord.salesPeriod)

    $scope.clientData = data.clientData
   

    vendorClientAccountId = $stateParams.vendorClientAccountId
    
    vatmUrl = "https://vatm-" + ENV.ENV + ".lyricfinancial.com"
    common.setupLyricSnippet(vendorClientAccountId, 'Global Music Distribution', vatmUrl)
    .then (lyric) ->
      $scope.lyric = lyric

    $scope.requestAdvance = ->
      data.registerUser(vendorClientAccountId, $scope.clientData, $scope.fileOptions, vendorId)
      .then (accessToken) ->
        if accessToken?
          $scope.lyric.advanceRequestComplete(accessToken)
      .catch (error) ->
        $scope.lyric.advanceRequestError(error)

    document.addEventListener 'confirmationComplete', $scope.requestAdvance

    $scope.$on '$destroy', ->
      document.removeEventListener 'confirmationComplete', $scope.requestAdvance
])

