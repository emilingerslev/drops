q = require('q')
elasticsearch = require('elasticsearch')
es = new elasticsearch.Client
  host: 'localhost:9200'
  # log: 'trace'

amqp = require('amqp')

pipes =
  es: es
  mq: amqp.createConnection({ host: 'localhost' })
  queues: {}
  initialize: ->
    defered = q.defer()
    console.log 'estabilishing connection to RabbitMQ'
    @mq.on 'ready', () =>
      console.log 'Connection etastablished to RabbitMQ'
      
      #connection.exchange('rings', type: 'direct')
      
      # connection.queue 'drops', durable: yes, (q) =>
      #   @queues.drops = q
      defered.resolve()
      
    
    defered.prmoise

module.exports = pipes