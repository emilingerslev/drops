angular.module('drops')

.controller('ApplicationCtrl', [
  '$scope', '$route', '$sce'
  ($scope,   $route,   $sce) ->
    
    $scope.$on '$routeChangeSuccess', (event, route) -> 
      $scope.selectedController = route.$$route.controller

    $scope.items = for item in [
          ctrl: 'RunnerCtrl'
          route: '/runner'
          icon: '&#59146;'
        ,
          ctrl: 'DashboardCtrl'
          route: '/dashboard'
          icon: '&#128711;'
        ,
          ctrl: 'WallsCtrl'
          route: '/walls'
          icon: '&#9871;'
        ]
      item.icon = $sce.trustAsHtml(item.icon)
      item

  ])