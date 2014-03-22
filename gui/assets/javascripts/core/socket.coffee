angular.module('drops')


.factory('socket', ($rootScope) ->
  (location) ->
    socket = io.connect(location)
    
    on: (eventName, callback) ->
      socketListener = (args...) ->  
        console.log eventName, args
        $rootScope.$emit('activity')
        $rootScope.$apply ->
          callback.apply(socket, args)
      socket.on eventName, socketListener
      -> 
        socket.removeListener(eventName, socketListener)
    emit: (eventName, data, callback) ->
      socket.emit eventName, data, (args...) ->
        $rootScope.$apply () ->
          if (callback)
            callback.apply(socket, args)
)