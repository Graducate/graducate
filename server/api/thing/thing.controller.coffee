###*
# Using Rails-like standard naming convention for endpoints.
# GET     /things              ->  index
# POST    /things              ->  create
# GET     /things/:id          ->  show
# PUT     /things/:id          ->  update
# DELETE  /things/:id          ->  destroy
###

'use strict'

_ = require('lodash')
Thing = require('./thing.model')

# Get list of things
exports.index = (req, res) ->
  Thing.find { disabled: { $ne: true } }, (err, things) ->
    if err then return handleError(res, err)
    res.status(200).json things

# Get a single thing
exports.show = (req, res) ->
  Thing.findById req.params.id, (err, thing) ->
    if err then return handleError(res, err)
    if !thing or thing.disabled then return res.status(404).send('Not Found')
    res.json thing

# Creates a new thing in the DB.
exports.create = (req, res) ->
  Thing.create req.body, (err, thing) ->
    if err
      return handleError(res, err)
    res.status(201).json thing

# Updates an existing thing in the DB.
exports.update = (req, res) ->
  if req.body._id
    delete req.body._id
  Thing.findById req.params.id, (err, thing) ->
    if err then return handleError(res, err)
    if !thing or thing.disabled then return res.status(404).send('Not Found')
    updated = _.merge(thing, req.body)
    updated.save (err) ->
      if err then return handleError(res, err)
      res.status(200).json thing

# Deletes a thing from the DB.
exports.destroy = (req, res) ->
  Thing.findById req.params.id, (err, thing) ->
    if err then return handleError res, err
    if !thing then return handleError res, new Error 'No thing found'

    thing.disabled = true

    thing.save (err, thing) ->
      if err then return handleError res, err

      res.status(204).send 'No Content'

handleError = (res, err) ->
  res.status(500).send err
