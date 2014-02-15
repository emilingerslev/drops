angular.module('drops')

.factory('socket', ($rootScope) ->
  socket = io.connect('http://localhost:3300')
  
  on: (eventName, callback) ->
    socket.on eventName, (args...) ->  
      console.log eventName, args
      $rootScope.$emit('activity')
      $rootScope.$apply ->
        callback.apply(socket, args)
  emit: (eventName, data, callback) ->
    socket.emit eventName, data, (args...) ->
      $rootScope.$apply () ->
        if (callback)
          callback.apply(socket, args)
)

.directive('activity', ['$rootScope', ($rootScope) ->
  restrict: 'E'
  template: -> '&#9679;'
  link: ($scope, element, attrs) ->
    element.hide()
    $rootScope.$on 'activity', -> 
      element.fadeIn 'slow', ->
        element.fadeOut 'slow'
])

.factory('runner', [
  '$sce', 'socket'
  ($sce,   socket) ->

    statusData = null

    onStatus: (func) ->
      func(statusData) if statusData
      socket.on 'status', (data) ->
        statusData = data
        func(data)

    onOutput: (func) ->
      socket.on 'output', (data) ->
        func(name: data.name, content: $sce.trustAsHtml(data.content.replace(/\n/g,'<br/>')))

    enable: (app) ->
      socket.emit('enable', appName: app.name)

    disable: (app) ->
      socket.emit('disable', appName: app.name)
])

.controller('MainCtrl', [
  '$scope', 'runner'
  ($scope,   runner) ->

    $scope.outputs = {} 

    runner.onStatus (data) ->
      $scope.apps = data.apps
      $scope.selectedApp ?= $scope.apps[0]
      $scope.outputs[app.name] ?= '' for app in $scope.apps

    runner.onOutput (data) ->
      $scope.outputs[data.name] = data.content

    $scope.enable = (app) ->
      runner.enable app

    $scope.disable = (app) ->
      runner.disable app

    $scope.select = (app) ->
      $scope.selectedApp = app.name  
  ])


.factory('socket2', ($rootScope) ->
  socket = io.connect('http://localhost:3400')
  
  on: (eventName, callback) ->
    socket.on eventName, (args...) ->  
      console.log eventName, args
      $rootScope.$emit('activity')
      $rootScope.$apply ->
        callback.apply(socket, args)
  emit: (eventName, data, callback) ->
    socket.emit eventName, data, (args...) ->
      $rootScope.$apply () ->
        if (callback)
          callback.apply(socket, args)
)

.controller('DashboardCtrl', [
  '$scope', 'socket2'
  ($scope,   socket2) ->

    socket2.on 'update', (data) -> $scope.hits = data.hits.total

    $scope.search = (query) ->
      socket2.emit('search', {query})

    socket2.on 'searchResult', (data) ->
      $scope.data = data
  ])