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
      zipCode: '68123',
      vendorClientAccountId: 'ascaptest1269'
    };
    $scope.server = {
      url: "https://lyric-demo-server.herokuapp.com"
    };
    $scope.royaltyEarnings = {
      earnings: [
        {
          source: '',
          nameOnAccount: '',
          accountNumber: '',
          estimatedRoyalties: ''
        }, {
          source: '',
          nameOnAccount: '',
          accountNumber: '',
          estimatedRoyalties: ''
        }, {
          source: '',
          nameOnAccount: '',
          accountNumber: '',
          estimatedRoyalties: ''
        }
      ]
    };
    $scope.postType = {
      type: "json"
    };
    $scope.requestAdvance = function() {
      var req;
      req = {
        method: 'POST',
        url: $scope.server.url + '/clients/' + $scope.clientData.vendorClientAccountId + '/advance',
        headers: {
          'Content-Type': "application/json;"
        }
      };
      return $http(req).then(function(resp) {
        return advanceRequestComplete(resp.access_token);
      })["catch"](function() {
        return advanceRequestError();
      });
    };
    return document.addEventListener('confirmationComplete', $scope.requestAdvance);
  }
]);
