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
    angular.element(document).ready(function() {
      return document.getElementById('terms-container').innerHTML = "Custom Terms & Conditions";
    });
    $scope.clientData = {
      firstName: 'Paul',
      lastName: 'Williams',
      address1: '327 S 87 St',
      city: 'Omaha',
      state: 'NE',
      zipCode: '68123'
    };
    $scope.server = {
      url: "https://lyric-demo-server.herokuapp.com/clients/ascaptest123/advance_server"
    };
    $scope.options = {
      contentType: "application/json",
      royaltyEarningsContentType: "text/csv",
      filename: ""
    };
    $scope.requestAdvance = function() {
      var req, url;
      url = $scope.server.url;
      if (($scope.server.username != null) && ($scope.server.password != null) && ($scope.server.vendorId != null)) {
        url = url + '?username=' + $scope.server.username + '&password=' + $scope.server.password + '&vendorId=' + $scope.server.vendorId;
      }
      req = {
        method: 'POST',
        url: url,
        headers: {
          'Content-Type': "application/json"
        },
        data: {
          options: $scope.options
        }
      };
      return $http(req).then(function(resp) {
        return advanceRequestComplete(resp.headers().access_token);
      })["catch"](function(error) {
        return advanceRequestError(error);
      });
    };
    document.addEventListener('confirmationComplete', $scope.requestAdvance);
    return $scope.$on('$destroy', function() {
      return document.removeEventListener('confirmationComplete', $scope.requestAdvance);
    });
  }
]);
