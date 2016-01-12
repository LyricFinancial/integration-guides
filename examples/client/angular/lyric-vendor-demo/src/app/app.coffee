angular.module( 'lyricvendordemo', [
  'templates-app',
  'templates-common',
  'lyricvendordemo.demo',
  'ui.router',
  'lyricvendordemo.services',
  'base64',
  'ngMaterial'
  'ngMessages'
])
.factory '_', ->
  return window._

.config([
  '$stateProvider'
  '$urlRouterProvider'
  '$httpProvider'
  '$base64'
  ($stateProvider, $urlRouterProvider, $httpProvider, $base64) ->
    $urlRouterProvider.otherwise( '/demo' )

    auth = $base64.encode("ascap:WxjXgrzzGzrkPMv7hBFJ@PMkQX9e3e2N")
    $httpProvider.defaults.headers.post["Authorization"] = "Basic " + auth
])

.controller( 'AppCtrl', [
  '$scope'
  '$location'
  ($scope, $location) ->


])