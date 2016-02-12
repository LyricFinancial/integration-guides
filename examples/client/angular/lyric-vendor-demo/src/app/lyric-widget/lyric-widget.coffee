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
      url: '/lyric-widget?:memberToken',
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
          (clientData, $http, $stateParams) ->
            memberToken = $stateParams.memberToken

            if !memberToken?
              return new LyricWidget(null, null)
            req =
              method: 'GET'
              url: ENV.DEMO_SERVER_URL + '/token?memberToken=' + memberToken
              headers: 'Content-Type': "application/json"

            $http(req)
            .then (resp) ->
              widget = new LyricWidget(memberToken, null)
              widget.loadData(resp.headers().token)
              .then ->
                return widget
            .catch (error)->
              return new LyricWidget(memberToken, null)

            
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

