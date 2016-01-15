angular.module('lyricvendordemo.demo', ['ui.router', 'ui.bootstrap', 'ngFileUpload']).config([
  '$stateProvider', function($stateProvider) {
    $stateProvider.state('demo', {
      url: '/demo',
      views: {
        "main": {
          controller: 'DemoCtrl',
          templateUrl: 'demo/demo.tpl.html'
        }
      }
    });
    return {
      data: {
        pageTitle: 'Lyric Vendor Demo'
      }
    };
  }
]).controller('DemoCtrl', [
  '$scope', '_', '$filter', '$http', '$base64', function($scope, _, $filter, $http, $base64) {
    $scope.clientData = {
      firstName: 'Paul',
      lastName: 'Williams',
      address1: '327 S 87 St',
      email: 'test52@email.com',
      city: 'Omaha',
      state: 'NE',
      zipCode: '68123',
      vendorClientAccountId: 'ascaptest1269',
      taxEinTinSsn: '333-44-5547',
      tinType: 'ssn',
      phone: '2075554448',
      mobilePhone: '2075556648',
      bankName: 'TD Bank',
      bankAccountNumber: '12345678',
      bankRoutingNumber: '211274450',
      bankAccountType: 'checking'
    };
    $scope.api = {
      url: 'https://api.lyricfinancial.com/vendorAPI/v1/json/clients',
      vendorId: 'ascap',
      username: 'ascap',
      password: 'WxjXgrzzGzrkPMv7hBFJ@PMkQX9e3e2N',
      contentType: 'application/json'
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
    $scope.accountTypes = [
      {
        code: 'savings',
        description: 'Savings'
      }, {
        code: 'checking',
        description: 'Checking'
      }
    ];
    $scope.countries = ['United States', 'Canada'];
    $scope.submitted = false;
    $scope.interacted = function(field) {
      return $scope.submitted || field.$dirty;
    };
    $scope.submit = function(registrationForm, dob, royaltyEarningsFile, serverUrl) {
      $scope.submitted = true;
      if (!registrationForm.$valid) {
        return;
      }
      $scope.clientData.dob = $filter('date')(dob, 'yyyy-MM-dd');
      return confirm();
    };
    $scope.saveForm = function() {
      var auth, req;
      if ($scope.api.contentType === 'multipart/form-data') {
        Upload.upload({
          url: 'https://api.lyricfinancial.com/vendorAPI/v1/clients',
          file: $scope.royaltyEarningsFile,
          method: 'POST',
          headers: {
            'content-type': 'multipart/form-data',
            'vendorId': 'ascap'
          },
          fileName: 'doc.jpg',
          fileFormDataName: 'myFile',
          data: {
            'clientData': $scope.clientData
          }
        }).then(function() {
          return advanceRequestComplete(resp.headers().access_token);
        })["catch"](function() {
          return advanceRequestError();
        });
        return;
      }
      auth = $base64.encode($scope.api.username + ":" + $scope.api.password);
      req = {
        method: 'POST',
        url: $scope.api.url,
        headers: {
          'Content-Type': 'application/json',
          'vendorId': $scope.api.vendorId,
          'Authorization': "Basic " + auth
        },
        data: $scope.clientData
      };
      return $http(req).then(function(resp) {
        return advanceRequestComplete(resp.headers().access_token);
      })["catch"](function() {
        return advanceRequestError();
      });
    };
    document.addEventListener('confirmationComplete', $scope.saveForm);
    return $scope.$on('$destroy', function() {
      return document.removeEventListener('confirmationComplete', $scope.saveForm);
    });
  }
]);
