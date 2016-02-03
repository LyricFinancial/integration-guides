angular.module( 'lyricvendordemo.lyric-widget', [
  'ui.router'
  'ui.bootstrap'
  'ngSanitize'
])

.config([
  '$stateProvider'
  ($stateProvider) ->
    $stateProvider.state 'lyric-widget',
      url: '/lyric-widget',
      views:
        "main":
          controller: 'LyricWidgetCtrl',
          templateUrl: 'lyric-widget/lyric-widget.tpl.html'
      resolve:
        clientData: [
          () ->
            return {
              firstName: 'Paul',
              lastName: 'Williams',
              address1: '327 S 87 St',
              city: 'Omaha',
              state: 'NE',
              zipCode: '68123'
            }
        ]
        lyricWidget: [
          'clientData'
          '$http'
          (clientData, $http) ->

            req =
              method: 'GET'
              #url: 'http://demo.dev:8082/clients/' + client.vendorClientAccountId + '/advanceToken'
              url: 'http://demo.dev:8082/clients/a/advanceToken'
              headers: 'Content-Type': "application/json"

            $http(req)
            .then (resp) ->
              widget = new LyricWidget()
              widget.loadData(resp.headers().token)
              .then ->
                return widget
            .catch (error)->
              return new LyricWidget()

            
        ]
    data:{ pageTitle: 'Lyric Vendor Demo' }
])


.controller( 'LyricWidgetCtrl', [
  '$scope'
  'clientData'
  'lyricWidget'
  ($scope, clientData, lyricWidget) ->

    $scope.lyricWidget = lyricWidget.getWidget()
    $scope.clientData = clientData

])

