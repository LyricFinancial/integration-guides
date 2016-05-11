angular.module( 'lyricvendordemo.lyric-widget', [
  'ui.router'
  'ui.bootstrap'
  'ngSanitize'
])

.config([
  '$stateProvider'
  'ENV'
  ($stateProvider, ENV) ->
    $stateProvider.state 'lyric-widget',
      url: '/lyric-widget?:vendorClientAccountId',
      views:
        "main":
          controller: 'LyricWidgetCtrl',
          templateUrl: 'lyric-widget/lyric-widget.tpl.html'
      resolve:
        clientData: [
          () ->
            return {
              id: 'a'
              firstName: 'Paul',
              lastName: 'Williams',
              address1: '327 S 87 St',
              city: 'Omaha',
              state: 'NE',
              zipCode: '68123',
              memberToken: 'abcdefg'
            }
        ]
        lyricWidget: [
          'clientData'
          '$http'
          '$stateParams'
          'ENV'
          (clientData, $http, $stateParams, ENV) ->
            vendorClientAccountId = $stateParams.vendorClientAccountId

            if !vendorClientAccountId?
              return new LyricWidget(null, null)
            req =
              method: 'GET'
              url: ENV.DEMO_SERVER_URL + '/token?vendorClientAccountId=' + vendorClientAccountId
              headers: 'Content-Type': "application/json"

            $http(req)
            .then (resp) ->
              widget = new LyricWidget(vendorClientAccountId, ENV.WIDGET_SERVICES_HOST)
              widget.loadData(resp.headers().token)
              .then ->
                return widget
            .catch (error)->
              return new LyricWidget(null, null)

            
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

