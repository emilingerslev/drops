amqp = require('amqp')
connection = amqp.createConnection({ host: 'localhost' })
# Wait for connection to become established.

connection.on 'ready', () ->
  process.stdout.write("waiting")
  repeater = (time) ->
    time = if time % 10 is 0
      process.stdout.write(" sending. ")
      connection.publish("drops", { _time: new Date(), type: 'test', data: { hello: 'world' }}, {deliveryMode: 2})
      process.stdout.write("sent.\n")
      process.stdout.write("waiting")
      1
    else
      process.stdout.write(".")
      time + 1
    setTimeout (-> repeater(time)), 1000

  repeater(1)

  #connection.off 'ready'

  #,500

  # # Use the default 'amq.topic' exchange
  # connection.queue 'my-queue', (q) ->
  #   # Catch all messages
  #   q.bind('#')

  #   # Receive messages
  #   q.subscribe (message) ->
  #     # Print messages to stdout
  #     console.log(message)