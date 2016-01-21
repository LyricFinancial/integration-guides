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
  '$scope', '_', '$filter', '$http', '$base64', 'Upload', function($scope, _, $filter, $http, $base64, Upload) {
    angular.element(document).ready(function() {
      return document.getElementById('terms-container').innerHTML = "Custom Terms & Conditions";
    });
    $scope.clientData = {
      firstName: 'Paul',
      lastName: 'Williams',
      address1: '327 S 87 St',
      email: 'test131ai@email.com',
      city: 'Omaha',
      state: 'NE',
      zipCode: '68123',
      vendorClientAccountId: 'ascaptest1314ai',
      taxEinTinSsn: '322-14-1396',
      tinType: 'ssn',
      phone: '207-515-1696',
      mobilePhone: '207-515-2997',
      bankName: 'TD Bank',
      bankAccountNumber: '12345678',
      bankRoutingNumber: '211274450',
      bankAccountType: 'checking',
      gender: 'male'
    };
    $scope.api = {
      url: 'https://lyric-demo-server.herokuapp.com/clients/:vendorId/advance',
      vendorId: 'ascap',
      username: 'ascap',
      password: 'WxjXgrzzGzrkPMv7hBFJ@PMkQX9e3e2N',
      contentType: 'application/json',
      royaltyEarningsContentType: 'text/csv',
      ssnRequired: true
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
    $scope.submit = function(registrationForm, royaltyEarningsFile) {
      $scope.submitted = true;
      if (!registrationForm.$valid) {
        return;
      }
      $scope.api.url = $scope.api.url.replace(':vendorId', $scope.clientData.vendorClientAccountId);
      $scope.clientData.dob = $filter('date')(registrationForm.dob.$viewValue, 'yyyy-MM-dd');
      if (registrationForm.royaltyEarningsFile != null) {
        $scope.royaltyEarningsFile = registrationForm.royaltyEarningsFile.$viewValue;
      }
      return confirm();
    };
    $scope.saveForm = function() {
      var auth, req, request;
      auth = $base64.encode($scope.api.username + ":" + $scope.api.password);
      if ($scope.api.contentType === 'multipart/form-data') {
        request = Upload.upload({
          url: $scope.api.url,
          method: 'POST',
          fileName: 'royalties.csv',
          fileFormDataName: 'royaltyEarnings',
          data: {
            'royaltyEarnings': $scope.royaltyEarningsFile,
            'clientData': JSON.stringify($scope.clientData)
          }
        });
      } else {
        if ($scope.api.royaltyEarningsContentType === 'text/csv') {
          $scope.clientData.royaltyEarnings = $base64.encode($scope.api.csvData);
        }
        req = {
          method: 'POST',
          url: $scope.api.url,
          headers: {
            'content-type': 'application/json'
          },
          data: $scope.clientData
        };
        request = $http(req);
      }
      return request.then(function(resp) {
        return advanceRequestComplete(resp.headers().access_token);
      })["catch"](function(error) {
        return advanceRequestError(error);
      });
    };
    document.addEventListener('confirmationComplete', $scope.saveForm);
    return $scope.$on('$destroy', function() {
      return document.removeEventListener('confirmationComplete', $scope.saveForm);
    });
  }
]);
