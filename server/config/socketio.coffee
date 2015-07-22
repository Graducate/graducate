###*
# Socket.io configuration
###

onDisconnect = (socket) ->

onConnect = (socket) ->
  socket.on 'info', (data) ->
    console.info '[%s] %s', socket.address, JSON.stringify(data, null, 2)

  # Insert sockets below
  require('../api/thing/thing.socket').register socket

'use strict'
config = require('./environment')

module.exports = (socketio) ->
  socketio.on 'connection', (socket) ->
    socket.address =
      if socket.handshake.address != null
        socket.handshake.address.address + ':' + socket.handshake.address.port
      else
        process.env.DOMAIN
    socket.connectedAt = new Date
    # Call onDisconnect.
    socket.on 'disconnect', ->
      onDisconnect socket
      console.info '[%s] DISCONNECTED', socket.address
    # Call onConnect.
    onConnect socket
    console.info '[%s] CONNECTED', socket.address
