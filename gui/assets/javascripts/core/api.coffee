angular.module('drops')
.factory('api', [
  '$sce', 'socket'
  ($sce,   socket) ->
    dropsApi = socket('http://localhost:3300')

    statusData = null

    onStatus: (func) ->
      func(statusData) if statusData
      dropsApi.on 'status', (data) ->
        statusData = data
        func(data)

    on: (event, func) ->
      dropsApi.on event, func

    onAppStatus: (app, func) ->
      dropsApi.on 'status:' + app.name, (data) ->
        func(name: data.name, content: $sce.trustAsHtml(data.content.replace(/\n/g,'<br/>')))

    enable: (app) ->
      dropsApi.emit('enable', appName: app.name)

    disable: (app) ->
      dropsApi.emit('disable', appName: app.name)
])