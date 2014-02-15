amqp = require('amqp')
elasticsearch = require('elasticsearch')
es = new elasticsearch.Client
  host: 'localhost:9200',
  # log: 'trace'

es.ping(
  requestTimeout: 1000,
  hello: "elasticsearch!"
, (error) -> if error then console.trace 'ElasticSearch: cluster is down!' else console.info 'ElasticSearch: All is well')

connection = amqp.createConnection({ host: 'localhost' })
# Wait for connection to become established.
connection.on 'ready', () ->
  console.log "Connection to RabbitMQ established"
  # console.log('sending')
  # connection.publish("elasticsearch", "{_id: 1}")
  # console.log('sent')
  #connection.end()
  # Use the default 'amq.topic' exchange

  exchange = connection.exchange 'rings', type:'direct', () -> console.log 'open'
  
  connection.queue 'drops', durable: yes, (q) ->
    console.log "Queue created"
    # Catch all messages
    q.bind('#')

    # Receive messages
    q.subscribe (message) ->
      # Print messages to stdout
      #console.log(message)

      type = message.type ? 'unknown'

      es.index(
        index: 'drops_test'
        type: type 
        #id: '1'
        body: message.data
      , (err, resp) ->
        if err 
          console.trace "ElasticSearch index error: ", err
        else
          #console.log "ElasticSearch index ", resp 
      )

      console.log 'Published', type
      try
        exchange.publish type, message.data
      catch ex
        console.log ex