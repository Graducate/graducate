passport = require('passport')
LocalStrategy = require('passport-local').Strategy

exports.setup = (User, config) ->
  passport.use new LocalStrategy({
    usernameField: 'email'
    passwordField: 'password'
  }, (email, password, done) ->
    User.findOne { email: email.toLowerCase() }, (err, user) ->
      if err
        return done(err)
      if !user
        return done(null, false, message: 'Den här emailadressen är inte registrerad.')
      if user.disabled
        return done(null, false, message: 'Den här användaren är inaktiv.')
      if !user.authenticate(password)
        return done(null, false, message: 'Felaktigt lösenord.')
      done null, user
)
