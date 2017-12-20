angular.module("sharedDataService", [

])
.factory "SharedDataService", [
  "$q"
  "$http"
  "ENV"
  '$cookies'
  ($q, $http, ENV, $cookies) ->
    class SharedDataService

      constructor: () ->
        @strategy = null
        @asyncToken = null

        @fileRecords = null
        @clientData = null

        @distributorDefaultFileOptions = {frequencyInDays: 30, numberOfPeriods: 14, numberOfRecordsPerPeriod: 6, schemas: ['TunecoreDistributionSample']}
        @publisherDefaultFileOptions = {frequencyInDays: 182, numberOfPeriods: 2, schemas: ['SonyatvStatementSummary', 'SonyatvEarningsSummary', 'SonyatvSongSummary', 'SonyatvFinancialTransactions']}

        @useKnownFile = true
        
        @frequencyOptions = [
          {name: 'Monthly', value: 30},
          {name: 'Quarterly', value: 91},
          {name: 'Semi-Annual', value: 182},
          {name: 'Annual', value: 365}
        ]

        @knownFiles = [
          {name: '233102-57852 2VA', value: '233102-57852'},
          {name: '1011094-57852 2VA', value: '1011094-57852'},
          {name: '233101-57853 2VA', value: '233101-57853'},
          {name: '1011095-57853 2VA', value: '1011095-57853'},
          {name: '106161-56711 2VA', value: '106161-56711'},
          {name: '97970-56711 2VA + Dup VA', value: '97970-56711'},
          {name: '97970-60972 Dup VA', value: '97970-60972'},
          {name: '103452-9973', value: '103452-9973'},
          {name: '1543343-1381559', value: '1543343-1381559'},
          {name: '111703-39991', value: '111703-39991'},
          {name: '112702-18310', value: '112702-18310'},
          {name: '114122-19639', value: '114122-19639'},
          {name: '114784-20268', value: '114784-20268'},
          {name: '114962-20431', value: '114962-20431'},
          {name: '119005-23896', value: '119005-23896'},
          {name: '119127-23993', value: '119127-23993'}
        ]

      setClientData: (vCAId, masterClientId) ->

        if vCAId == 'jb123456'
          @clientData = {email: 'jump-ball@example.com', firstName: 'Jump', lastName: 'Ball Music Group', secureCellPhone: ''}
        else if vCAId == 'ezt123456'
          @clientData = {email: 'ez-tunes@example.com', firstName: 'EZ', lastName: 'Tunes', secureCellPhone: ''}
        else if vCAId == 'fb123456'
          @clientData = {email: 'fresh-beats@example.com', firstName: 'Fresh Beats', lastName: 'Music Group', secureCellPhone: ''}
        else if vCAId == 'eliLyricTest' || vCAId == '111703' || vCAId == '233102'
          @clientData = {email: 'eli_paypal@lyricfinancial.com', firstName: 'Eli', lastName: 'Ball', masterClientId: masterClientId}
        else if vCAId == 'ericLyricTest' || vCAId == '112702' || vCAId == '1011094'
          @clientData = {email: 'eric@lyricfinancial.com', firstName: 'Eric', lastName: 'Reuthe', masterClientId: masterClientId}
        else if vCAId == 'chuckLyricTest' || vCAId == '114122' || vCAId == '233101'
          @clientData = {email: 'cswanberg@mad-swan.com', firstName: 'Chuck', lastName: 'Swanberg', masterClientId: masterClientId}
        else if vCAId == 'amyLyricTest' || vCAId == '114784' || vCAId == '106161'
          @clientData = {email: 'amadden@mad-swan.com', firstName: 'Amy', lastName: 'Madden', masterClientId: masterClientId, secureCellPhone: '12077491513'}
        else
          @clientData =  {email: vCAId + '@example.com', firstName: 'Test', lastName: 'User', masterClientId: masterClientId}

        return @clientData

      getFileRecords: (vendorClientAccountId, fileOptions) ->

        data = {fileOptions: fileOptions, clientOptions: @clientData}


        req =
          method: 'POST'
          url: ENV.DEMO_SERVER_URL + '/clients/' + vendorClientAccountId + '/getfiledata'
          headers: {
            'content-type': 'application/json'
          }
          data: data

        $http(req)
        .then (resp) =>
          @fileRecords = resp.data
          return @fileRecords

      getStatementToken: (vendorClientAccountId, vendorId) ->

        req =
          method: 'GET'
          url: ENV.DEMO_SERVER_URL + '/statementtoken?vendorClientAccountId=' + vendorClientAccountId + '&vendorId=' + vendorId
          headers: {
            'content-type': 'application/json'
          }

        $http(req)
        .then (resp) =>
          return resp.headers().token

      registerUser: (vendorClientAccountId, clientData, fileOptions, vendorId) ->
        defer = $q.defer()

        headers = {'Content-Type': "application/json"}
        registrationEndpoint = 'advance'

        if @strategy == 'async'
          registrationEndpoint = 'advance_multi'
          headers = {'Content-Type': "application/json", 'async-token' : @asyncToken}
        
        url = ENV.DEMO_SERVER_URL + '/clients/' + vendorClientAccountId + '/' + registrationEndpoint

        data = {
          clientOptions: clientData,
          fileOptions: fileOptions,
          vendorId: vendorId
        }

        req =
          method: 'POST'
          url: url
          headers: headers
          data: data

        $http(req)
        .then (resp) =>
          if @strategy == 'async'
            defer.resolve()
            return
          defer.resolve(resp.headers()["access-token"])
        .catch (error)->
          if error.headers()["access-token"]?
            defer.resolve(error.headers()["access-token"])
            return
            
          defer.reject(error)

        return defer.promise

      getFileDataOptions: (cookieName, defaultFileOptions) ->
        fileOptionsCookie = $cookies.get(cookieName)

        if fileOptionsCookie?
          return JSON.parse(fileOptionsCookie)
        else
          return defaultFileOptions


    return new SharedDataService()
]