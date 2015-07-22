###*
# Broadcast updates to client when the model changes
###

onSave = (socket, doc, cb) ->
  socket.emit 'question:save', doc

onRemove = (socket, doc, cb) ->
  socket.emit 'question:remove', doc

'use strict'

Question = require('./question.model')

exports.register = (socket) ->
  Question.schema.post 'save', (doc) ->
    onSave socket, doc

  Question.schema.post 'remove', (doc) ->
    onRemove socket, doc
