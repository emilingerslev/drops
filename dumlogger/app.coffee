

# prompt = require('prompt');

# #
# # Start the prompt
# #
# prompt.start();

# #
# # Get two properties from the user: username and email
# #
# prompt.get(['username', 'email'], (err, result) ->
#   #
#   # Log the results.
#   #
#   console.log('Command-line input received:');
#   console.log('  username: ' + result.username);
#   console.log('  email: ' + result.email);
# )

log = require './log'
data = require './data'

log.config app: 'dumlogger', ->

  process.stdout.write("waiting")
  repeater = (time) ->
    time = if time % 10 is 0

      d = data.random()
      process.stdout.write(" sending #{d.username} #{d.ua} ")
      log.info 'login', d
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
