###*
# Using Rails-like standard naming convention for endpoints.
# GET     /questions              ->  index
# POST    /questions              ->  create
# GET     /questions/:id          ->  show
# PUT     /questions/:id          ->  update
# DELETE  /questions/:id          ->  destroy
###
'use strict'

_ = require('lodash')
Question = require('./question.model')

# Get list of questions
exports.index = (req, res) ->
  Question.find()
  .populate 'creator'
  .exec (err, questions) ->
    if err
      return handleError(res, err)
    res.status(200).json questions

# Get a single question
exports.show = (req, res) ->
  Question.findById req.params.id
  .populate 'creator'
  .exec (err, question) ->
    if err
      return handleError(res, err)
    if !question
      return res.status(404).send('Not Found')
    res.json question

# Creates a new question in the DB.
exports.create = (req, res) ->
  Question.create req.body, (err, question) ->
    if err
      return handleError(res, err)
    res.status(201).json question

# Updates an existing question in the DB.
exports.update = (req, res) ->
  if req.body._id
    delete req.body._id
  Question.findById req.params.id, (err, question) ->
    if err
      return handleError(res, err)
    if !question
      return res.status(404).send('Not Found')
    updated = _.merge(question, req.body)
    updated.save (err) ->
      if err
        return handleError(res, err)
      res.status(200).json question

# Deletes a question from the DB.
exports.destroy = (req, res) ->
  Question.findById req.params.id, (err, question) ->
    if err
      return handleError(res, err)
    if !question
      return res.status(404).send('Not Found')
    question.remove (err) ->
      if err
        return handleError(res, err)
      res.status(204).send 'No Content'

handleError = (res, err) ->
  res.send 500, err