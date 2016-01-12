angular.module('lyricvendordemo', ['templates-app', 'templates-common', 'lyricvendordemo.demo', 'ui.router', 'lyricvendordemo.services', 'base64', 'ngMaterial', 'ngMessages']).factory('_', function() {
  return window._;
}).config([
  '$stateProvider', '$urlRouterProvider', '$httpProvider', '$base64', function($stateProvider, $urlRouterProvider, $httpProvider, $base64) {
    var auth;
    $urlRouterProvider.otherwise('/demo');
    auth = $base64.encode("ascap:WxjXgrzzGzrkPMv7hBFJ@PMkQX9e3e2N");
    return $httpProvider.defaults.headers.post["Authorization"] = "Basic " + auth;
  }
]).controller('AppCtrl', ['$scope', '$location', function($scope, $location) {}]);
