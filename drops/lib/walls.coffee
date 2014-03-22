{es,mq, queues} = require './pipes'
_ = require 'underscore'

class walls extends require('events').EventEmitter

  status: ->
    es.search
      index: 'drops'
      type: 'walls'
      #q: 'test'
    .then (body) ->
      _.map body.hits.hits, (x) -> 
        wall = x._source
        _.extend wall, id: x._id
        wall
    , (err) ->
      console.trace(err)
    .then (walls) =>
      for wall in walls
        @emit 'wall-update', wall

module.exports = new walls 


# mq.queue 'drops', durable: yes, (q) ->
#   q.subscribe (message) ->
#     walls.status()

  
