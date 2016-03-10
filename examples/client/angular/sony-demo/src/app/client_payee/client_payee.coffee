angular.module( 'sonydemo.client_payee', [
  'ui.router'
  'userRepository'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'client_payee',
      url: '/client_payee?:vendorClientAccountId',
      # params : { vendorClientAccountId: null }
      views:
        "main":
          controller: 'ClientPayeeCtrl',
          templateUrl: 'client_payee/client_payee.tpl.html'
      resolve:
        clientData: [
          'UserRepository'
          '$stateParams'
          '$state'
          '$q'
          '$timeout'
          (userRepo, $stateParams, $state, $q, $timeout) ->
            vendorClientAccountId = $stateParams.vendorClientAccountId
            user = userRepo.lookupUser(vendorClientAccountId)

            defer = $q.defer()

            if user.vendorAccount.vendorClientAccountId == null
              $timeout ->
                $state.go 'login'
              defer.reject()
              return

            defer.resolve(user)

            return defer.promise
        ]
    data:{ pageTitle: 'Sony Demo' }

])


.controller( 'ClientPayeeCtrl', [
  '$scope'
  '_'
  '$filter'
  '$http'
  'ENV'
  'clientData'
  '$stateParams'
  ($scope, _, $filter, $http, ENV, clientData, $stateParams) ->


    
])

