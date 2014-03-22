angular.module('drops')
.factory('wall', (socket) ->
  wall = socket('http://localhost:3400')
  
  onUpdate: (listener) ->
    wall.on 'update', (data) -> listener(data.hits.total)

  onSearch: (listener) ->
    wall.on 'searchResult', (data) -> listener(data)

  search: (query) ->
    wall.emit('search', {query})
)