(function() {
  var all, path, requiredProcessEnv, _;

  requiredProcessEnv = function(name) {
    if (!process.env[name]) {
      throw new Error('You must set the ' + name + ' environment variable');
    }
    return process.env[name];
  };

  'use strict';

  path = require('path');

  _ = require('lodash');

  all = {
    env: process.env.NODE_ENV,
    root: path.normalize(__dirname + '/../../..'),
    port: process.env.PORT || 9000,
    seedDB: false,
    secrets: {
      session: process.env.SESSION_SECRET || 'graducate-secret'
    },
    userRoles: ['guest', 'user', 'admin'],
    mongo: {
      options: {
        db: {
          safe: true
        }
      }
    }
  };

  module.exports = _.merge(all, require('./' + process.env.NODE_ENV + '.js') || {});

}).call(this);

//# sourceMappingURL=index.js.map
