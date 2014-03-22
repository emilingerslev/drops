angular.module('drops')
.controller('DashboardCtrl', [
  '$scope', 'wall'
  ($scope,   wall) ->

    $scope.query = 'mozilla'

    $scope.search = ->
      wall.search($scope.query)

    l1 = wall.onUpdate (hits) -> 
      $scope.hits = hits
      $scope.search()

    l2 = wall.onSearch (data) -> 
      parser = new UAParser()
      $scope.data = _.reduce(data.search.hits.hits, (agg, hit) ->
        parser.setUA(hit._source.ua)
        result = parser.getResult()
        agg[result.browser.name] ?= 0
        agg[result.browser.name] += 1
        agg
      , {})

    $scope.$on '$destroy', ->
      l1?()
      l2?()
  ])