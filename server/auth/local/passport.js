(function() {
  var LocalStrategy, passport;

  passport = require('passport');

  LocalStrategy = require('passport-local').Strategy;

  exports.setup = function(User, config) {
    return passport.use(new LocalStrategy({
      usernameField: 'email',
      passwordField: 'password'
    }, function(email, password, done) {
      return User.findOne({
        email: email.toLowerCase()
      }, function(err, user) {
        if (err) {
          return done(err);
        }
        if (!user) {
          return done(null, false, {
            message: 'Den här emailadressen är inte registrerad.'
          });
        }
        if (user.disabled) {
          return done(null, false, {
            message: 'Den här användaren är inaktiv.'
          });
        }
        if (!user.authenticate(password)) {
          return done(null, false, {
            message: 'Felaktigt lösenord.'
          });
        }
        return done(null, user);
      });
    }));
  };

}).call(this);

//# sourceMappingURL=passport.js.map
