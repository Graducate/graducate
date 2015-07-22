
/**
 * Socket.io configuration
 */

(function() {
  var config, onConnect, onDisconnect;

  onDisconnect = function(socket) {};

  onConnect = function(socket) {
    socket.on('info', function(data) {
      return console.info('[%s] %s', socket.address, JSON.stringify(data, null, 2));
    });
    return require('../api/thing/thing.socket').register(socket);
  };

  'use strict';

  config = require('./environment');

  module.exports = function(socketio) {
    return socketio.on('connection', function(socket) {
      socket.address = socket.handshake.address !== null ? socket.handshake.address.address + ':' + socket.handshake.address.port : process.env.DOMAIN;
      socket.connectedAt = new Date;
      socket.on('disconnect', function() {
        onDisconnect(socket);
        return console.info('[%s] DISCONNECTED', socket.address);
      });
      onConnect(socket);
      return console.info('[%s] CONNECTED', socket.address);
    });
  };

}).call(this);

//# sourceMappingURL=socketio.js.map
