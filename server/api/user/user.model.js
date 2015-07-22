(function() {
  'use strict';
  var Schema, UserSchema, crypto, mongoose, validPhoneNumber, validateIsExpected, validatePresenceOf;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  crypto = require('crypto');

  UserSchema = new Schema({
    firstName: String,
    lastName: String,
    email: {
      type: String,
      lowercase: true
    },
    role: {
      type: String,
      "default": 'user'
    },
    hashedPassword: String,
    provider: String,
    salt: String
  });


  /**
   * Virtuals
   */

  UserSchema.virtual('password').set(function(password) {
    this._password = password;
    this.salt = this.makeSalt();
    this.hashedPassword = this.encryptPassword(password);
  }).get(function() {
    return this._password;
  });

  UserSchema.virtual('fullName').get(function() {
    return "" + this.firstName + " " + this.lastName;
  });

  UserSchema.virtual('profile').get(function() {
    return {
      _id: this._id,
      firstName: this.firstName,
      lastName: this.lastName,
      fullName: this.firstName + ' ' + this.lastName,
      role: this.role
    };
  });

  UserSchema.virtual('token').get(function() {
    return {
      _id: this._id,
      role: this.role
    };
  });


  /**
   * Validations
   */

  UserSchema.path('email').validate((function(email) {
    return email.length;
  }), 'Email cannot be blank');

  UserSchema.path('hashedPassword').validate((function(hashedPassword) {
    return hashedPassword.length;
  }), 'Password cannot be blank');

  UserSchema.path('email').validate((function(value, respond) {
    var self;
    self = this;
    this.constructor.findOne({
      email: value
    }, function(err, user) {
      if (err) {
        throw err;
      }
      if (user) {
        if (self.id === user.id) {
          return respond(true);
        }
        return respond(false);
      }
      respond(true);
    });
  }), 'The specified email address is already in use.');

  validatePresenceOf = function(value) {
    return value && value.length;
  };

  validateIsExpected = function(value, expectedValue) {
    return value === expectedValue;
  };

  validPhoneNumber = function(i) {
    i = i.replace(/\D/g, '').replace(/^46/, '0').replace(/^0/, '0046');
    if (i.length === 13 && i[4] === '7') {
      return i;
    } else {
      return false;
    }
  };


  /**
   * Pre-save hook
   */

  UserSchema.pre('save', function(next) {
    if (!this.isNew) {
      return next();
    }
    if (!validatePresenceOf(this.hashedPassword)) {
      return next(new Error('Invalid password'));
    } else {
      return next();
    }
  });


  /**
   * Methods
   */

  validPhoneNumber = function(i) {
    i = i.replace(/\D/g, '').replace(/^46/, '0').replace(/^0/, '0046');
    if (i.length === 13 && i[4] === '7') {
      return i;
    } else {
      return false;
    }
  };

  UserSchema.methods = {
    authenticate: function(plainText) {
      return this.encryptPassword(plainText) === this.hashedPassword;
    },
    makeSalt: function() {
      return crypto.randomBytes(16).toString('base64');
    },
    encryptPassword: function(password) {
      var salt;
      if (!password || !this.salt) {
        return '';
      }
      salt = new Buffer(this.salt, 'base64');
      return crypto.pbkdf2Sync(password, salt, 10000, 64).toString('base64');
    }
  };

  module.exports = mongoose.model('User', UserSchema);

}).call(this);

//# sourceMappingURL=user.model.js.map
