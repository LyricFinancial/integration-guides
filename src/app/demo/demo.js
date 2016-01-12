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
    $stateProvider.state('demo.view', {
      views: {
        'userInfo': {
          templateUrl: 'demo/_my_membership.tpl.html'
        }
      }
    });
    $stateProvider.state('demo.edit', {
      views: {
        'userInfo': {
          templateUrl: 'demo/_my_membership_edit.tpl.html'
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
  '$scope', '$uibModal', '$state', '_', '$filter', 'Client', function($scope, $uibModal, $state, _, $filter, Client) {
    var year;
    $scope.clientData = {
      firstName: 'Paul',
      lastName: 'Williams',
      address1: '327 S 87 St',
      email: 'test93@email.com',
      city: 'Omaha',
      state: 'NE',
      zipCode: '68123',
      vendorClientAccountId: 'ascaptest1241',
      ssn: '333-44-5593',
      phone: '2075554493',
      mobilePhone: '2075556693',
      bankName: 'abc',
      bankAccountNumber: '12345678',
      bankRoutingNumber: '211274450',
      bankAccountType: 'checking'
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
    $scope.days = _.range(1, 32);
    year = new Date().getFullYear();
    $scope.years = _.range(year, year - 100, -1);
    $scope.postType = {
      type: "json"
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
    $scope.months = [
      {
        month: '01',
        description: 'January'
      }, {
        month: '02',
        description: 'February'
      }, {
        month: '03',
        description: 'March'
      }, {
        month: '04',
        description: 'April'
      }, {
        month: '05',
        description: 'May'
      }, {
        month: '06',
        description: 'June'
      }, {
        month: '07',
        description: 'July'
      }, {
        month: '08',
        description: 'August'
      }, {
        month: '09',
        description: 'September'
      }, {
        month: '10',
        description: 'October'
      }, {
        month: '11',
        description: 'November'
      }, {
        month: '12',
        description: 'December'
      }
    ];
    $scope.countries = ['United States', 'Canada'];
    $scope.submitted = false;
    $scope.interacted = function(field) {
      return $scope.submitted || field.$dirty;
    };
    $scope.submit = function(registrationForm, dob, royaltyEarningsFile) {
      $scope.submitted = true;
      if (!registrationForm.$valid) {
        return;
      }
      $scope.clientData.dob = $filter('date')(dob, 'yyyy-MM-dd');
      return confirm();
    };
    $scope.saveForm = function() {
      if ($scope.postType.type === 'form') {
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
          return advanceRequestComplete(resp.headers.ACCESS_TOKEN);
        })["catch"](function() {
          return advanceRequestError();
        });
        return;
      }
      return Client.save($scope.clientData).$promise.then(function(resp) {
        return advanceRequestComplete(resp.headers.access_token);
      })["catch"](function() {
        return advanceRequestError();
      });
    };
    document.addEventListener('confirmationComplete', $scope.saveForm);
    return $state.go('demo.edit');
  }
]);
