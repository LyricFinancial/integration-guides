angular.module("commonLyricServices", ['sharedDataService'])
.factory "CommonLyricServices", [
  "$q"
  '$http'
  '$stateParams'
  'ENV'
  'SharedDataService'
  ($q, $http, $stateParams, ENV, data) ->

    class CommonLyricServices

      setupLyricWidget: (vendorClientAccountId, widget, vendorId) ->
        defer = $q.defer()

        req =
          method: 'GET'
          url: ENV.DEMO_SERVER_URL + '/token?vendorClientAccountId=' + vendorClientAccountId + '&vendorId=' + vendorId
          headers: 'Content-Type': "application/json"

        # Get token to make loadData call
        $http(req)
        .then (resp) ->
          widget.loadData(resp.headers().token)
          .then ->
            defer.resolve(widget)
        .catch (error)->

        return defer.promise

      setupLyricSnippet: (vendorClientAccountId, vendorName, vatmUrl) ->
        terms = "<p>" + vendorName + " has partnered with Lyric Financial - a secure online service that helps songwriters and publishers squash short-term cash-flow worries. Advances from Lyric Financial give you the comfort of knowing you can get the money you need, when you need it.</p>
        <ul>
          <li>Instant setup and approval - as a " + vendorName + " member you're already set!</li>
          <li>Simple fee, no subscription or hidden costs</li>
          <li>No credit hassles, no monthly payments</li>
        </ul>

        <p>By clicking 'I Agree' you grant " + vendorName + " permission to share your royalty history with Lyric Financial. You will be taken to Lyric Financial's website to complete this process.</p>"

        defer = $q.defer()
        data.strategy = 'syncManualRedirect'

        if $stateParams.strategy?
          data.strategy = $stateParams.strategy

        if data.strategy == 'async'
      
          req =
            method: 'GET'
            url: ENV.DEMO_SERVER_URL + '/asynctoken?vendorClientAccountId=' + vendorClientAccountId
            headers: 'Content-Type': "application/json"

          $http(req)
          .then (resp) =>
            data.asyncToken = resp.headers().token
            lyric = new LyricSnippet(terms, data.strategy, data.asyncToken, vatmUrl)
            defer.resolve(lyric)
          .catch (error)->
        else
          lyric = new LyricSnippet(terms, data.strategy, null, vatmUrl)
          defer.resolve(lyric)

        return defer.promise

    return new CommonLyricServices()
]
