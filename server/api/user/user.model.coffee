'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
crypto = require('crypto')

UserSchema = new Schema
  firstName: String
  lastName: String
  email:
    type: String
    lowercase: true
  role:
    type: String,
    default: 'user'
  hashedPassword: String
  provider: String
  salt: String

###*
# Virtuals
###

UserSchema.virtual('password').set (password) ->
  @_password = password
  @salt = @makeSalt()
  @hashedPassword = @encryptPassword(password)
  return
.get ->
  @_password

UserSchema.virtual('fullName').get ->
  "#{this.firstName} #{this.lastName}"

# Public profile information
UserSchema.virtual('profile').get ->
  {
    _id: @_id
    firstName: @firstName
    lastName: @lastName
    fullName: @firstName + ' ' + @lastName
    role: @role
  }

# Non-sensitive info we'll be putting in the token
UserSchema.virtual('token').get ->
  {
    _id: @_id
    role: @role
  }

###*
# Validations
###

# Validate empty email
UserSchema.path('email').validate ((email) ->
  email.length
), 'Email cannot be blank'
# Validate empty password
UserSchema.path('hashedPassword').validate ((hashedPassword) ->
  hashedPassword.length
), 'Password cannot be blank'
# Validate email is not taken
UserSchema.path('email').validate ((value, respond) ->
  self = this
  @constructor.findOne { email: value }, (err, user) ->
    if err
      throw err
    if user
      if self.id == user.id
        return respond(true)
      return respond(false)
    respond true
    return
  return
), 'The specified email address is already in use.'

validatePresenceOf = (value) ->
  value and value.length

validateIsExpected = (value, expectedValue) ->
  value is expectedValue

validPhoneNumber = (i) ->
  i = i.replace /\D/g, ''
  .replace /^46/, '0'
  .replace /^0/, '0046'
  (if i.length is 13 and i[4] is '7' then i else false)


###*
# Pre-save hook
###

UserSchema.pre 'save', (next) ->
    if !this.isNew then return next()

    if !validatePresenceOf this.hashedPassword
      next(new Error('Invalid password'))
    else
      next()

###*
# Methods
###

validPhoneNumber = (i) ->
  i = i.replace /\D/g, ''
    .replace /^46/, '0'
    .replace /^0/, '0046'
    (if i.length is 13 and i[4] is '7' then i else false)

UserSchema.methods =
  authenticate: (plainText) ->
    return this.encryptPassword(plainText) is this.hashedPassword
  makeSalt: ->
    crypto.randomBytes(16).toString 'base64'
  encryptPassword: (password) ->
    if !password or !@salt
      return ''
    salt = new Buffer(@salt, 'base64')
    crypto.pbkdf2Sync(password, salt, 10000, 64).toString 'base64'


module.exports = mongoose.model('User', UserSchema)
