angular.module("sharedDataService", [

])
.factory "SharedDataService", [
  "$q"
  "$http"
  "ENV"
  ($q, $http, ENV) ->
    class SharedDataService

      constructor: () ->
        @fileRecords = null
        @clientData = null

        @frequencyOptions = [
          {name: 'Monthly', value: 30},
          {name: 'Quarterly', value: 91},
          {name: 'Semi-Annual', value: 182},
          {name: 'Annual', value: 365}
        ]

      setClientData: (vendorClientAccountId, masterClientId) ->

        if vendorClientAccountId == 'eliLyricTest'
          @clientData = {email: 'eli_paypal@lyricfinancial.com', firstName: 'Eli', lastName: 'Ball', masterClientId: masterClientId}
        else if vendorClientAccountId == 'ericLyricTest'
          @clientData = {email: 'eric@lyricfinancial.com', firstName: 'Eric', lastName: 'Reuthe', masterClientId: masterClientId}
        else if vendorClientAccountId == 'chuckLyricTest'
          @clientData = {email: 'cswanberg@mad-swan.com', firstName: 'Chuck', lastName: 'Swanberg', masterClientId: masterClientId}
        else if vendorClientAccountId == 'amyLyricTest'
          @clientData = {email: 'amadden@mad-swan.com', firstName: 'Amy', lastName: 'Madden', masterClientId: masterClientId}
        else
          @clientData =  {email: vendorClientAccountId + '@email.com', firstName: 'Test', lastName: 'User', masterClientId: masterClientId}

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
          defer.reject(error)

        return defer.promise


    return new SharedDataService()
]