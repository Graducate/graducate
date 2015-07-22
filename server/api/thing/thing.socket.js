
/**
 * Broadcast updates to client when the model changes
 */

(function() {
  var onRemove, onSave, thing;

  onSave = function(socket, doc, cb) {
    return socket.emit('thing:save', doc);
  };

  onRemove = function(socket, doc, cb) {
    return socket.emit('thing:remove', doc);
  };

  'use strict';

  thing = require('./thing.model');

  exports.register = function(socket) {
    thing.schema.post('save', function(doc) {
      return onSave(socket, doc);
    });
    return thing.schema.post('remove', function(doc) {
      return onRemove(socket, doc);
    });
  };

}).call(this);

//# sourceMappingURL=thing.socket.js.map
