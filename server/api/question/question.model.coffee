'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema

CommentSchema = new Schema
  body: String
  creator:
    type: Schema.Types.ObjectId
    ref: 'User'
  dateCreated:
    type: Date
    default: Date.now
  dateModified:
    type: Date
    default: Date.now
  active:
    type: Boolean
    default: true

AnswerSchema = new Schema
  body: String
  comments: [CommentSchema]
  creator:
    type: Schema.Types.ObjectId
    ref: 'User'
  dateCreated:
    type: Date
    default: Date.now
  dateModified:
    type: Date
    default: Date.now
  active:
    type: Boolean
    default: true

QuestionSchema = new Schema
  title: String
  body: String
  creator:
    type: Schema.Types.ObjectId
    ref: 'User'
  answers: [AnswerSchema]
  dateCreated:
    type: Date
    default: Date.now
  dateModified:
    type: Date
    default: Date.now
  active:
    type: Boolean
    default: true

module.exports = mongoose.model('Question', QuestionSchema)