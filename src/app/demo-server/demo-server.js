angular.module('lyricvendordemo.demo-server', ['ui.router', 'ui.bootstrap', 'ngFileUpload']).config([
  '$stateProvider', function($stateProvider) {
    $stateProvider.state('demo-server', {
      url: '/demo-server',
      views: {
        "main": {
          controller: 'DemoServerCtrl',
          templateUrl: 'demo-server/demo-server.tpl.html'
        }
      }
    });
    return {
      data: {
        pageTitle: 'Lyric Vendor Demo'
      }
    };
  }
]).controller('DemoServerCtrl', [
  '$scope', '$state', '_', '$filter', '$http', function($scope, $state, _, $filter, $http) {
    $scope.clientData = {
      firstName: 'Paul',
      lastName: 'Williams',
      address1: '327 S 87 St',
      city: 'Omaha',
      state: 'NE',
      zipCode: '68123'
    };
    $scope.server = {
      url: "https://lyric-demo-server.herokuapp.com/clients/ascaptest123/advance"
    };
    $scope.options = {
      contentType: "application/json",
      jsonRoyaltyEarningsContentType: "text/csv",
      multipartRoyaltyEarningsContentType: "text/csv"
    };
    $scope.requestAdvance = function() {
      var req;
      req = {
        method: 'POST',
        url: $scope.server.url,
        headers: {
          'Content-Type': "application/json;"
        },
        data: $scope.options
      };
      return $http(req).then(function(resp) {
        return advanceRequestComplete(resp.data.access_token);
      })["catch"](function() {
        return advanceRequestError();
      });
    };
    document.addEventListener('confirmationComplete', $scope.requestAdvance);
    return $scope.$on('$destroy', function() {
      return document.removeEventListener('confirmationComplete', $scope.requestAdvance);
    });
  }
]);
