
/**
 * Broadcast updates to client when the model changes
 */

(function() {
  var Question, onRemove, onSave;

  onSave = function(socket, doc, cb) {
    return socket.emit('question:save', doc);
  };

  onRemove = function(socket, doc, cb) {
    return socket.emit('question:remove', doc);
  };

  'use strict';

  Question = require('./question.model');

  exports.register = function(socket) {
    Question.schema.post('save', function(doc) {
      return onSave(socket, doc);
    });
    return Question.schema.post('remove', function(doc) {
      return onRemove(socket, doc);
    });
  };

}).call(this);

//# sourceMappingURL=question.socket.js.map
