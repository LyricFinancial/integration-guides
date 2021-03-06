angular.module( 'lyricdemo.assignments', [
  'ui.router'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'assignments',
      url: '/assignments?vendorClientAccountId',
      views:
        "main":
          controller: 'AssignmentsCtrl',
          templateUrl: 'assignments/assignments.tpl.html'
      resolve:
          assignments: [
            '$stateParams'
            '$http'
            'ENV'
            ($stateParams, $http, ENV) ->
              vendorClientAccountId = $stateParams.vendorClientAccountId

              req =
                method: 'GET'
                url: ENV.TUNECORE_DEMO_SERVER_URL + '/clients/' + vendorClientAccountId + '/assignments'
                headers: 'Content-Type': "application/json"

              $http(req)
              .then (resp) ->
                return resp.data
          ]
    data:{ pageTitle: 'TuneCore Demo' }

])


.controller( 'AssignmentsCtrl', [
  '$scope'
  'assignments'
  ($scope, assignments) ->
    $scope.assignments = assignments
])

