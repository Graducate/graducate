'use strict';

User = require('./user.model')
passport = require('passport')
config = require('../../config/environment')
jwt = require('jsonwebtoken')

validationError = (res, err) ->
  return res.status(422).json(err)

###* 
# Get list of users
# restriction: 'admin'
### 
exports.index = (req, res) ->
  User.find {}, '-salt -hashedPassword', (err, users) ->
    if err then return res.status(500).send(err)
    res.status(200).json users

###* 
# Creates a new user
### 
exports.create = (req, res, next) ->
  newUser = new User req.body
  newUser.provider = 'local'
  newUser.role = 'user'
  newUser.save (err, user) ->
    if err then return validationError res, err
    token = jwt.sign {_id: user._id }, config.secrets.session, { expiresInMinutes: 60*5 }
    res.json { token: token }

###*
# Get a single user
###
exports.show = (req, res, next) ->
  userId = req.params.id;

  User.findById userId, '-salt -hashedPassword', (err, user) ->
    if err then return next(err)
    if !user then return res.status(401).send 'Unauthorized'
    res.status(200).json user
###*
# Deletes a user
# restriction: 'admin'
###
exports.destroy = (req, res) ->
  User.findByIdAndRemove req.params.id, (err, user) ->
    if err then return res.status(500).send(err)
    return res.status(204).send('No Content')

###*
# Change a users password
###
exports.changePassword = (req, res, next) ->
  userId = req.user._id
  oldPass = String(req.body.oldPassword)
  newPass = String(req.body.newPassword)

  User.findById userId, (err, user) ->
    if user.authenticate(oldPass)
      user.password = newPass
      user.save (err) ->
        if err then return validationError(res, err)
        res.status(200).send('OK')
    else
      res.status(403).send('Forbidden')
###*
# Get my info
###
exports.me = (req, res, next) ->
  userId = req.user._id
  User.findOne
    _id: userId
  , '-salt -hashedPassword'
  , (err, user) -> # don't ever give out the password or salt
    if err then return next(err);
    if !user then return res.status(401).send('Unauthorized')
    res.status(200).json(user)

###*
# Authentication callback
###
exports.authCallback = (req, res, next) ->
  res.redirect('/')
