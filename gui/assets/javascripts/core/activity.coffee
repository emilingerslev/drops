angular.module('drops')
.directive('activity', ['$rootScope', ($rootScope) ->
  restrict: 'E'
  template: -> '&#9679;'
  link: ($scope, element, attrs) ->
    element.hide()
    $rootScope.$on 'activity', -> 
      element.fadeIn 'slow', ->
        element.fadeOut 'slow'
])