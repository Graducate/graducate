'use strict'

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV or 'development'
express = require('express')
mongoose = require('mongoose')
config = require('./config/environment')

mongoose.connect config.mongo.uri, config.mongo.options

# Populate DB with sample data
if config.seedDB
  require './config/seed'

# Setup server
app = express()
server = require('http').createServer(app)
socketio = require('socket.io')(server,
  serveClient: if config.env == 'production' then false else true
  path: '/socket.io-client')
require('./config/socketio') socketio
require('./config/express') app
require('./routes') app

# Start server
server.listen config.port, config.ip, ->
  console.log 'Express server listening on %d, in %s mode', config.port, app.get('env')
  return

# Expose app
exports = module.exports = app

