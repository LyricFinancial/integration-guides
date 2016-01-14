angular.module('lyricvendordemo', ['templates-app', 'templates-common', 'lyricvendordemo.demo', 'lyricvendordemo.demo-server', 'ui.router', 'base64', 'ngMaterial', 'ngMessages']).factory('_', function() {
  return window._;
}).config([
  '$stateProvider', '$urlRouterProvider', '$httpProvider', function($stateProvider, $urlRouterProvider, $httpProvider) {
    return $urlRouterProvider.otherwise('/demo');
  }
]).controller('AppCtrl', ['$scope', '$location', function($scope, $location) {}]);
