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
      url: '/distributor?vendorClientAccountId&:masterClientId&:strategy',
      views:
        "main":
          controller: 'DistributorCtrl',
          templateUrl: 'distributor/distributor.tpl.html'
      resolve:
        init: [
          '$stateParams'
          '$state'
          '$q'
          'SharedDataService'
          ($stateParams, $state, $q, data) ->
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
  ($scope, $http, ENV, $stateParams, common, data, _, $cookies) ->
    vendorId = "demodistributor"
    $scope.vendorType = 'distributor'

    $scope.data = data
    if data.clientData == null
      alert('no user record')

    fileOptionsCookie = $cookies.get('distributorFileOptions')

    if fileOptionsCookie?
      $scope.fileOptions = JSON.parse(fileOptionsCookie)
    else
      $scope.fileOptions = {frequencyInDays: 30, numberOfPeriods: 14, numberOfRecordsPerPeriod: 6, schemas: ['TunecoreDistributionSample']}

    $scope.$watchGroup ['fileOptions.frequencyInDays', 'fileOptions.numberOfPeriods', 'fileOptions.numberOfRecordsPerPeriod'], (newValue, oldValue) ->
      $scope.reloadFileRecords()

    $scope.reloadFileRecords = ->
      $cookies.put('distributorFileOptions', JSON.stringify($scope.fileOptions))
      data.getFileRecords(vendorClientAccountId, $scope.fileOptions)
      .then ->
        $scope.fileRecords = _(data.fileRecords).first 15

        firstRecord = _(data.fileRecords).first()
        lastRecord = _(data.fileRecords).last()

        $scope.firstRecordDate = new Date(firstRecord.salesPeriod)
        $scope.lastRecordDate = new Date(lastRecord.salesPeriod)

    $scope.clientData = data.clientData
   

    vendorClientAccountId = $stateParams.vendorClientAccountId
    
    widgetUrl = "https://" + vendorId + "-widget-" + ENV.ENV + ".lyricfinancial.com"
    widget = new LyricWidget(vendorClientAccountId, widgetUrl)
    $scope.lyricWidget = widget.getWidget()

    $scope.reloadWidget = (vendorId) ->
      common.setupLyricWidget(vendorClientAccountId, widget, vendorId)
      .then (widget) ->
        $scope.lyricWidget = widget.getWidget()

    
    vatmUrl = "https://vatm-" + ENV.ENV + ".lyricfinancial.com"
    common.setupLyricSnippet(vendorClientAccountId, 'Demo Distributor', vatmUrl)
    .then (lyric) ->
      $scope.lyric = lyric

    $scope.options = {
      contentType: "application/json"
      royaltyEarningsContentType: "text/csv"
      filename: ""
    }

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

