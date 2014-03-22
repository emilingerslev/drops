angular.module('drops')

.controller('WallsCtrl', [
  '$scope', '$route', 'api'
  ($scope,   $route,   api) ->
    
    l1 = api.on 'wall-update', (data) ->
      console.log 'wall-update'
      $scope.walls[data.id] = data

    $scope.walls = {}
    
  ])