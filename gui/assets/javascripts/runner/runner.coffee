angular.module('drops')
.controller('RunnerCtrl', [
  '$scope', 'api'
  ($scope,   api) ->
    l1 = null
    $scope.outputs = {} 

    api.onStatus (data) ->
      $scope.apps = data.apps
      $scope.selectedApp ?= $scope.apps[0]
      $scope.outputs[app.name] ?= '' for app in $scope.apps

    $scope.enable = (app) ->
      api.enable app

    $scope.disable = (app) ->
      api.disable app

    $scope.select = (app) ->
      l1?()
      $scope.selectedApp = app.name  

      l1 = api.onAppStatus app, (data) ->
        $scope.outputs[data.name] = data.content

    $scope.$on '$destroy', ->
      l1?()
  ])