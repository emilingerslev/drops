server = require('./lib/server')
apps = require('./lib/apps')


path = require 'path'

runnerDirectory = __dirname
appsDirectory = path.resolve(__dirname + "/../")

apps.initialize {appsDirectory}, ->

  server.start
    port: process.env.PORT ? 3300


