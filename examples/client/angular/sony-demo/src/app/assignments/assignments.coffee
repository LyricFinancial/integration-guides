angular.module( 'sonydemo.assignments', [
  'ui.router'
  'userRepository'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'assignments',
      url: '/assignments',
      views:
        "main":
          controller: 'AssignmentsCtrl',
          templateUrl: 'assignments/assignments.tpl.html'
      resolve:
          assignments: [
            '$stateParams'
            ($stateParams) ->
              vendorClientAccountId = $stateParams.vendorClientAccountId
              
              assignments = [
                {assignmentDate: '2016-03-02T17:12:15.135', amount: '$500'},
                {assignmentDate: '2016-03-09T12:48:15.835', amount: '$200'}
              ]
          ]
    data:{ pageTitle: 'Sony Demo' }

])


.controller( 'AssignmentsCtrl', [
  '$scope'
  'assignments'
  ($scope, assignments) ->
    $scope.assignments = assignments
])

