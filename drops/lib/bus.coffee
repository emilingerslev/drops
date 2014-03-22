amqp = require('amqp')
connection = amqp.createConnection({ host: 'localhost' })
# Wait for connection to become established.

module.exports =

  config: (config, ready) -> 
    connection.on 'ready', () ->
      connection.queue 'drops_runner', durable: yes, (q) ->
        ready()

  send: (target, data) ->
    connection.publish("drops_runner", { _time: new Date(), app: app, data: data}, {deliveryMode: 2})
      