
/**
 * Using Rails-like standard naming convention for endpoints.
 * GET     /things              ->  index
 * POST    /things              ->  create
 * GET     /things/:id          ->  show
 * PUT     /things/:id          ->  update
 * DELETE  /things/:id          ->  destroy
 */

(function() {
  'use strict';
  var Thing, handleError, _;

  _ = require('lodash');

  Thing = require('./thing.model');

  exports.index = function(req, res) {
    return Thing.find({
      disabled: {
        $ne: true
      }
    }, function(err, things) {
      if (err) {
        return handleError(res, err);
      }
      return res.status(200).json(things);
    });
  };

  exports.show = function(req, res) {
    return Thing.findById(req.params.id, function(err, thing) {
      if (err) {
        return handleError(res, err);
      }
      if (!thing || thing.disabled) {
        return res.status(404).send('Not Found');
      }
      return res.json(thing);
    });
  };

  exports.create = function(req, res) {
    return Thing.create(req.body, function(err, thing) {
      if (err) {
        return handleError(res, err);
      }
      return res.status(201).json(thing);
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return Thing.findById(req.params.id, function(err, thing) {
      var updated;
      if (err) {
        return handleError(res, err);
      }
      if (!thing || thing.disabled) {
        return res.status(404).send('Not Found');
      }
      updated = _.merge(thing, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(res, err);
        }
        return res.status(200).json(thing);
      });
    });
  };

  exports.destroy = function(req, res) {
    return Thing.findById(req.params.id, function(err, thing) {
      if (err) {
        return handleError(res, err);
      }
      if (!thing) {
        return handleError(res, new Error('No thing found'));
      }
      thing.disabled = true;
      return thing.save(function(err, thing) {
        if (err) {
          return handleError(res, err);
        }
        return res.status(204).send('No Content');
      });
    });
  };

  handleError = function(res, err) {
    return res.status(500).send(err);
  };

}).call(this);

//# sourceMappingURL=thing.controller.js.map
