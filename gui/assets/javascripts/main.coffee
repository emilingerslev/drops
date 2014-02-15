﻿angular.module('drops', ['ngRoute'])

  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
    .when '/main',
      templateUrl: 'main'
      controller: 'MainCtrl'
    .when '/dashboard',
      templateUrl: 'dashboard'
      controller: 'DashboardCtrl'
    .otherwise 
      redirectTo: '/main'
  ]

  # load templates build with mimosa
  .run(['$templateCache', '$route', ($templateCache, $route) ->
    for template,content of window.templates
      $templateCache.put template, content()
    $route.reload()
  ])