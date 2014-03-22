angular.module('drops')
.directive('wallPresenter', [() ->
  restrict: 'E'
  template: -> '<pre></pre>'
  scope:
    data: "="
  link: ($scope, element, attrs) ->
    $scope.$watch 'data', ->
      element.find('> pre').text(JSON.stringify($scope.data, null, 2))
])