angular.module('d3', [])
  .factory('d3', ($document, $q, $rootScope) ->
    d = $q.defer()
    onScriptLoad = () ->
      # Load client in the browser
      $rootScope.$apply () -> d.resolve(window.d3)
    
    # Create a script tag with d3 as the source
    # and call our onScriptLoad callback when it
    # has been loaded
    scriptTag = $document[0].createElement('script')
    scriptTag.type = 'text/javascript' 
    scriptTag.async = true
    scriptTag.src = 'http://d3js.org/d3.v3.min.js'
    scriptTag.onreadystatechange = () ->
      if @readyState is 'complete'
        onScriptLoad()
        
    scriptTag.onload = onScriptLoad

    s = $document[0].getElementsByTagName('body')[0]
    s.appendChild(scriptTag);

    # resize: 
    #   # Browser onresize event
    #   window.onresize = () -> 
    #     scope.$apply()

    #   # Watch for resize event
    #   $rootScope.$watch(() ->
    #     angular.element(window)[0].innerWidth
    #   , () ->
    #     $rootScope.render(scope.data)
    #   )
 
    (target) -> 
      d.promise.then target
  )