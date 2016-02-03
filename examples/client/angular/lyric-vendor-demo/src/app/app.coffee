angular.module( 'lyricvendordemo', [
  'templates-app',
  'templates-common',
  'lyricvendordemo.demo',
  'lyricvendordemo.demo-server',
  'lyricvendordemo.lyric-widget',
  'ui.router',
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
  ($stateProvider, $urlRouterProvider, $httpProvider) ->
    $urlRouterProvider.otherwise( '/demo' )
])

.controller( 'AppCtrl', [
  '$scope'
  '$location'
  ($scope, $location) ->
    
])