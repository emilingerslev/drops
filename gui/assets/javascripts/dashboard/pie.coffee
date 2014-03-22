angular.module('drops')
  .directive('pie', (d3) ->
    restrict: 'E'
    scope: 
      data: '='
      label: "@"
    link: (scope, element, attrs) ->

      d3 (d3) ->

        # margin = parseInt(attrs.margin ? 20)
        # barHeight = parseInt(attrs.barHeight ? 20)
        # barPadding = parseInt(attrs.barPadding ? 5)

        # svg = d3.select(element[0])
        #   .append('svg')
        #   .style('width', '100%')
        #   #.attr('preserveAspectRatio', 'xMinYMin meet')

        # scope.$watch('data', (newVals, oldVals) ->
        #   scope.render(newVals);
        # , true)

        # scope.render = (data) ->
          
        #   # remove all previous items before render
        #   svg.selectAll('*').remove();

        #   # If we don't pass any data, return out of the element
        #   return if not data
            

        #   # setup variables
        #   width = d3.select(element[0]).node().offsetWidth - margin
        #   # calculate the height
        #   height = scope.data.length * (barHeight + barPadding)
        #   # Use the category20() scale function for multicolor support
        #   color = d3.scale.category20()
        #   # our xScale
        #   xScale = d3.scale.linear()
        #     .domain([0, d3.max(data, (d) -> d.score)])
        #     .range([0, width])

        #   #svg.attr('viewBox', "0 0 100 #{height}")

        #   # set the height based on the calculations above
        #   svg.attr('height', height)

        #   # create the rectangles for the bar chart
        #   svg.selectAll('rect')
        #     .data(data).enter()
        #       .append('rect')
        #       .attr('height', barHeight)
        #       .attr('width', 140)
        #       .attr('x', 0)
        #       .attr('y', (d,i) ->
        #         i * (barHeight + barPadding)
        #       )
        #       .attr('fill', (d) -> color(d.score))
        #       .transition()
        #         .duration(1000)
        #         .attr('width', (d) ->
        #           xScale(d.score)
        #         )

        #   svg.selectAll("text")
        #       .data(data)
        #       .enter()
        #         .append("text")
        #         .attr("fill", "#fff")
        #         .attr("y", (d, i) -> i * (barHeight + barPadding) + margin - barPadding)
        #         .attr("x", 15)
        #         .text((d) -> d[scope.label])

        diameter = 1000
        radius = diameter / 2

        color = d3.scale.category20()

        pie = d3.layout.pie()
          .sort(null)
          .value((d) -> d.count)

        arc = d3.svg.arc()
          .innerRadius(radius - diameter / 5)
          .outerRadius(radius)

        svg = d3.select(element[0]).append("svg")
          .style('width', '100%')
          .style("height", '100%')
          .attr('viewBox', "0 0 #{diameter} #{diameter}")
          .attr('preserveAspectRatio', 'xMinYMin meet')
          .append("g")
          .attr("transform", "translate(" + diameter / 2 + "," + diameter / 2 + ")")

        update = (data) ->

          g = svg.selectAll(".arc")
              .data(pie(data))

          genter = g
            .enter().append("g")
            .attr("class", "arc")
          
          g.exit().remove()

          g.append("path")
              .attr("d", arc)
              .style("fill", (d) -> color(d.data.name))

          g.append("text")
              .attr("transform", (d) -> "translate(" + arc.centroid(d) + ")")
              .attr("dy", ".35em")
              .style("text-anchor", "middle")
              .text((d) -> return d.data.name);

        scope.$watch('data', (newVals, oldVals) ->
          if newVals
            update({name,count} for name,count of newVals)
          #scope.render(newVals);
        , true)

)