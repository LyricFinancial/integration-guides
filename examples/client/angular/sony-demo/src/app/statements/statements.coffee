angular.module( 'sonydemo.statements', [
  'ui.router'
  'userRepository'
  'ngSanitize'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'statements',
      url: '/statements?:vendorClientAccountId',
      views:
        "main":
          controller: 'StatementsCtrl',
          templateUrl: 'statements/statements.tpl.html'
      resolve:
        clientData: [
          'UserRepository'
          '$stateParams'
          '$state'
          '$q'
          (userRepo, $stateParams, $state, $q) ->
            vendorClientAccountId = $stateParams.vendorClientAccountId
            userRepo.setUser(vendorClientAccountId)

            defer = $q.defer()

            if userRepo.clientData.account.vendorAccount.vendorClientAccountId == null
              $state.go 'login'
              .then ->
                defer.reject()
              return
            else
              defer.resolve()

            return defer.promise
        ]
    data:{ pageTitle: 'Sony Demo' }

])


.controller( 'StatementsCtrl', [
  '$scope'
  '$http'
  'ENV'
  'UserRepository'
  ($scope, $http, ENV, userRepo) ->
    $scope.clientData = userRepo.clientData

    terms = "<p>Sony has partnered with Lyric Financial - a secure online service that helps songwriters and publishers squash short-term cash-flow worries. Advances from Lyric Financial give you the comfort of knowing you can get the money you need, when you need it.</p>

        <ul>
          <li>Instant setup and approval - as a Sony member you're already set!</li>
          <li>Simple fee, no subscription or hidden costs</li>
          <li>No credit hassles, no monthly payments</li>
        </ul>

        <p>By clicking 'I Agree' you grant Sony permission to share your royalty history with Lyric Financial. You will be taken to Lyric Financial's website to complete this process.</p>"

    widget = new LyricWidget($scope.clientData.account.vendorAccount.vendorClientAccountId, null)
    $scope.lyric = new LyricSnippet(terms, "https://vatm-dev.lyricfinancial.com")

    # Display placeholder widget
    $scope.lyricWidget = widget.getWidget()

    if $scope.clientData.account.user?
      req =
        method: 'GET'
        url: ENV.SONY_DEMO_SERVER_URL + '/token?vendorClientAccountId=' + $scope.clientData.account.vendorAccount.vendorClientAccountId
        headers: 'Content-Type': "application/json"

      # Get token to make loadData call
      $http(req)
      .then (resp) ->
        widget.loadData(resp.headers().token)
        .then ->
          # Update widget to include returned data
          $scope.lyricWidget = widget.getWidget()
      .catch (error)->
    

    $scope.options = {
      contentType: "application/json"
      royaltyEarningsContentType: "text/csv"
      filename: ""
    }

    $scope.requestAdvance = ->
      url = ENV.SONY_DEMO_SERVER_URL + '/clients/' + $scope.clientData.account.vendorAccount.vendorClientAccountId + '/advance_client'

      req =
        method: 'POST'
        url: url
        headers: 'Content-Type': "application/json"
        data: $scope.clientData.account

      $http(req)
      .then (resp) ->
        $scope.lyric.advanceRequestComplete(resp.headers().access_token)
      .catch (error)->
        $scope.lyric.advanceRequestError(error)

    document.addEventListener 'confirmationComplete', $scope.requestAdvance

    $scope.$on '$destroy', ->
      document.removeEventListener 'confirmationComplete', $scope.requestAdvance
])

