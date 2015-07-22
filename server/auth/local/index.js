(function() {
  'use strict';
  var auth, express, passport, router;

  express = require('express');

  passport = require('passport');

  auth = require('../auth.service');

  router = express.Router();

  router.post('/', function(req, res, next) {
    return passport.authenticate('local', function(err, user, info) {
      var error, token;
      error = err || info;
      if (error) {
        return res.status(401).json(error);
      }
      if (!user) {
        return res.status(404).json({
          message: 'Something went wrong, please try again.'
        });
      }
      token = auth.signToken(user._id, user.role);
      return res.json({
        token: token
      });
    })(req, res, next);
  });

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map
