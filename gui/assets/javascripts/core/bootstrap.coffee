angular.module('drops', ['ngRoute', 'd3'])

  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
    .when '/runner',
      templateUrl: 'runner'
      controller: 'RunnerCtrl'
    .when '/dashboard',
      templateUrl: 'dashboard'
      controller: 'DashboardCtrl'
    .when '/walls',
      templateUrl: 'walls'
      controller: 'WallsCtrl'
    .otherwise 
      redirectTo: '/runner'
  ]

  # load templates build with mimosa
  .run(['$templateCache', '$route', ($templateCache, $route) ->
    for template,content of window.templates
      $templateCache.put template, content()
    $route.reload()
  ])