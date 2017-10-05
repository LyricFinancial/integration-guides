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
      url: '/publisher?vendorClientAccountId&:masterClientId&:strategy&:vendorId',
      views:
        "main":
          controller: 'PublisherCtrl',
          templateUrl: 'publisher/publisher.tpl.html'
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


.controller( 'PublisherCtrl', [
  '$scope'
  '$http'
  'ENV'
  '$stateParams'
  'CommonLyricServices'
  'SharedDataService'
  '_'
  '$cookies'
  '$state'
  '$auth'
  ($scope, $http, ENV, $stateParams, common, data, _, $cookies, $state, $auth) ->
    $scope.isAuthenticated = $auth.isAuthenticated()

    vendorId = 'demopublisher'

    if $stateParams.vendorId?
      vendorId = $stateParams.vendorId

    $scope.vendorType = 'publisher'
    $scope.clientData = data.clientData
    vendorClientAccountId = $stateParams.vendorClientAccountId
    masterClientId = $stateParams.masterClientId

    selectedKnownFile = vendorClientAccountId

    $scope.setPreviousState($scope.vendorType, vendorClientAccountId, masterClientId)

    if masterClientId?
      selectedKnownFile += '-' + masterClientId

    $scope.selectedKnownFile = selectedKnownFile

    $scope.data = data
    if data.clientData == null
      alert('no user record')

    $scope.fileOptions = data.getFileDataOptions('publisherFileOptions', data.publisherDefaultFileOptions)

    $scope.$watchGroup ['fileOptions.frequencyInDays', 'fileOptions.numberOfPeriods'], (newValue, oldValue) ->
      $scope.reloadFileRecords()

    $scope.selectedKnownFileChanged = (value) ->
      paramParts = value.split('-')
      $state.go 'publisher',
        'vendorClientAccountId': paramParts[0]
        'masterClientId': paramParts[1]
        'vendorId': vendorId

    $scope.reloadFileRecords = ->
      $cookies.put('publisherFileOptions', JSON.stringify($scope.fileOptions))
      data.getFileRecords(vendorClientAccountId, $scope.fileOptions)
      .then ->
        $scope.fileRecords = _(data.fileRecords).first 15

        firstRecord = _(data.fileRecords).first()
        lastRecord = _(data.fileRecords).last()

        $scope.closingBalance = firstRecord.closingBalanceAmount

        $scope.firstRecordDate = new Date(firstRecord.statementDate.split(" ")[0])
        $scope.lastRecordDate = new Date(lastRecord.statementDate.split(" ")[0])

    vendorClientAccountId = $stateParams.vendorClientAccountId
    
    vatmUrl = "https://vatm-" + ENV.ENV + ".lyricfinancial.com"
    common.setupLyricSnippet(vendorClientAccountId, 'Demo Publisher', vatmUrl)
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

