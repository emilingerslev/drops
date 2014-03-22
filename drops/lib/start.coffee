q = require 'q'
server = require './server'
apps = require './apps'
pipes = require './pipes'

path = require 'path'

runnerDirectory = __dirname
appsDirectory = path.resolve(__dirname + "/../../")

q.all [
  apps.initialize({appsDirectory})
  pipes.initialize()
]
.done ->
  server.start
    port: process.env.PORT ? 3300


