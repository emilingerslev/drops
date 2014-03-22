amqp = require('amqp')
connection = amqp.createConnection({ host: 'localhost' })
# Wait for connection to become established.

app = null

module.exports =

  config: (config, ready) -> 
    app = config.app
    connection.on 'ready', () ->
      ready()

  info: (type, data) ->
    connection.publish("drops", { _time: new Date(), type: type, app: app, data: data}, {deliveryMode: 2})
      