angular.module( 'lyricdemo.publisher', [
  'ui.router'
  'ngSanitize'
  'commonLyricServices'
  'sharedDataService'
  'ngCookies'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'publisher',
      url: '/publisher?vendorClientAccountId&:masterClientId&:strategy',
      views:
        "main":
          controller: 'PublisherCtrl',
          templateUrl: 'publisher/publisher.tpl.html'
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


.controller( 'PublisherCtrl', [
  '$scope'
  '$http'
  'ENV'
  '$stateParams'
  'CommonLyricServices'
  'SharedDataService'
  '_'
  '$cookies'
  ($scope, $http, ENV, $stateParams, common, data, _, $cookies) ->
    vendorId = 'demopublisher'
    $scope.vendorType = 'publisher'
    $scope.clientData = data.clientData

    $scope.data = data
    if data.clientData == null
      alert('no user record')

    fileOptionsCookie = $cookies.get('publisherFileOptions')

    if fileOptionsCookie?
      $scope.fileOptions = JSON.parse(fileOptionsCookie)
    else
      $scope.fileOptions = {frequencyInDays: 182, numberOfPeriods: 2, schemas: ['SonyatvStatementSummary', 'SonyatvEarningsSummary', 'SonyatvSongSummary', 'SonyatvFinancialTransactions']}

    $scope.$watchGroup ['fileOptions.frequencyInDays', 'fileOptions.numberOfPeriods'], (newValue, oldValue) ->
      $scope.reloadFileRecords()

    $scope.reloadFileRecords = ->
      $cookies.put('publisherFileOptions', JSON.stringify($scope.fileOptions))
      data.getFileRecords(vendorClientAccountId, $scope.fileOptions)
      .then ->
        $scope.fileRecords = _(data.fileRecords).first 15

        firstRecord = _(data.fileRecords).first()
        lastRecord = _(data.fileRecords).last()

        $scope.closingBalance = firstRecord.closingBalanceAmount

        $scope.firstRecordDate = new Date(firstRecord.statementDate)
        $scope.lastRecordDate = new Date(lastRecord.statementDate)

    vendorClientAccountId = $stateParams.vendorClientAccountId
    
    vatmUrl = "https://vatm-" + ENV.ENV + ".lyricfinancial.com"
    common.setupLyricSnippet(vendorClientAccountId, 'Demo Publisher', vatmUrl)
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

