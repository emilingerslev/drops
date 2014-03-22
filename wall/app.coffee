express = require 'express'
socketio = require 'socket.io'

elasticsearch = require('elasticsearch')
es = new elasticsearch.Client
  host: 'localhost:9200',
  # log: 'trace'

amqp = require('amqp')


port = process.env.PORT or 3400

app = express()
server = app.listen port, ->
  console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env

io = socketio.listen(server)
app.configure ->
  app.set 'port', port
  app.use express.favicon()
  app.use express.urlencoded()
  app.use express.json()
  app.use express.methodOverride()
  app.use express.compress()

io.sockets.on('connection', (socket) ->
  es.search(
    index: 'drops_test',
    #type: ,
    #q: 'test'
  ).then((body) ->
    console.log body
    io.sockets.emit('update', body)
  , (err) ->
    console.trace(err)
  )
  # socket.on('private message', (from, msg) ->
  #   console.log('I received a private message by ', from, ' saying ', msg)
  # )

  # socket.on('disconnect', () ->
  #   io.sockets.emit('user disconnected')
  # )

  socket.on('search', (data) ->
    es.search(
      index: 'drops_test',
      #type: ,
      body:
        from: 0
        size: 1000
        query:
          match:
            _all: data.query
    ).then((body) ->
      socket.emit('searchResult', query: data.query, search: body)
    , (err) ->
      console.trace(err)
    )
    
  )
)

console.log 'estabilishing connection to RabbitMQ'
connection = amqp.createConnection({ host: 'localhost' })
connection.on 'ready', () ->
  console.log 'Connection etastablished to RabbitMQ'
  connection.exchange('rings', type: 'direct')
  connection.queue 'drops_wall', durable: yes, (q) ->
    console.log "Queue created"
    q.bind('rings','login')

    q.subscribe (message) ->
      console.log message
      es.search(
        index: 'drops_test',
        #type: ,
        #q: 'test'
      ).then((body) ->
        console.log body
        io.sockets.emit('update', body)
      , (err) ->
        console.trace(err)
      )

app.configure 'development', ->
  app.use express.errorHandler()

#app.get '/', routes.index(config)