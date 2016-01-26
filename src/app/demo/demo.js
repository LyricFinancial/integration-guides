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
      user: {
        firstName: 'Paul',
        lastName: 'Williams',
        address1: '327 S 87 St',
        email: '',
        city: 'Omaha',
        state: 'NE',
        zipCode: '68123',
        phone: '',
        mobilePhone: '',
        gender: 'male',
        maritalStatus: 'single'
      },
      vendorAccount: {
        vendorClientAccountId: ''
      },
      taxInfo: {
        taxEinTinSsn: '',
        tinType: 'ssn',
        memberBusinessType: 'individual'
      },
      bankInfo: {
        bankName: 'TD Bank',
        bankAccountNumber: '12345678',
        bankRoutingNumber: '211274450',
        bankAccountType: 'checking'
      }
    };
    $scope.api = {
      url: 'https://lyric-demo-server.herokuapp.com/clients/:vendorId/advance_client',
      contentType: 'application/json',
      royaltyEarningsContentType: 'text/csv',
      ssnRequired: true
    };
    $scope.genders = [
      {
        code: 'male',
        description: 'Male'
      }, {
        code: 'female',
        description: 'Female'
      }
    ];
    $scope.maritalStatuses = [
      {
        code: 'single',
        description: 'Single'
      }, {
        code: 'married',
        description: 'Married'
      }, {
        code: 'separated',
        description: 'Separated'
      }, {
        code: 'divorced',
        description: 'Divorced'
      }, {
        code: 'widowed',
        description: 'Widowed'
      }
    ];
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
      $scope.api.url = $scope.api.url.replace(':vendorId', $scope.clientData.vendorAccount.vendorClientAccountId);
      $scope.clientData.user.dob = $filter('date')(registrationForm.dob.$viewValue, 'yyyy-MM-dd');
      if (registrationForm.royaltyEarningsFile != null) {
        $scope.royaltyEarningsFile = registrationForm.royaltyEarningsFile.$viewValue;
      }
      return confirm();
    };
    $scope.saveForm = function() {
      var req, request, url;
      url = $scope.api.url;
      if (($scope.api.username != null) && ($scope.api.password != null) && ($scope.api.vendorId != null)) {
        url = url + '?username=' + $scope.api.username + '&password=' + $scope.api.password + '&vendorId=' + $scope.api.vendorId;
      }
      if ($scope.api.ssnRequired === false && $scope.isBlank($scope.clientData.taxInfo.taxEinTinSsn)) {
        delete $scope.clientData.taxInfo;
      }
      if ($scope.api.contentType === 'multipart/form-data') {
        request = Upload.upload({
          url: url,
          method: 'POST',
          fileName: 'royalties.csv',
          fileFormDataName: 'royaltyEarnings',
          data: {
            'royaltyEarnings': $scope.royaltyEarningsFile,
            'clientData': JSON.stringify($scope.clientData)
          }
        });
      } else {
        req = {
          method: 'POST',
          url: url,
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
    $scope.$on('$destroy', function() {
      return document.removeEventListener('confirmationComplete', $scope.saveForm);
    });
    return $scope.isBlank = function(str) {
      return !str || /^\s*$/.test(str);
    };
  }
]);
