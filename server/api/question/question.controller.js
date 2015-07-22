
/**
 * Using Rails-like standard naming convention for endpoints.
 * GET     /questions              ->  index
 * POST    /questions              ->  create
 * GET     /questions/:id          ->  show
 * PUT     /questions/:id          ->  update
 * DELETE  /questions/:id          ->  destroy
 */

(function() {
  'use strict';
  var Question, handleError, _;

  _ = require('lodash');

  Question = require('./question.model');

  exports.index = function(req, res) {
    return Question.find().populate('creator').exec(function(err, questions) {
      if (err) {
        return handleError(res, err);
      }
      return res.status(200).json(questions);
    });
  };

  exports.show = function(req, res) {
    return Question.findById(req.params.id).populate('creator').exec(function(err, question) {
      if (err) {
        return handleError(res, err);
      }
      if (!question) {
        return res.status(404).send('Not Found');
      }
      return res.json(question);
    });
  };

  exports.create = function(req, res) {
    return Question.create(req.body, function(err, question) {
      if (err) {
        return handleError(res, err);
      }
      return res.status(201).json(question);
    });
  };

  exports.update = function(req, res) {
    if (req.body._id) {
      delete req.body._id;
    }
    return Question.findById(req.params.id, function(err, question) {
      var updated;
      if (err) {
        return handleError(res, err);
      }
      if (!question) {
        return res.status(404).send('Not Found');
      }
      updated = _.merge(question, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(res, err);
        }
        return res.status(200).json(question);
      });
    });
  };

  exports.destroy = function(req, res) {
    return Question.findById(req.params.id, function(err, question) {
      if (err) {
        return handleError(res, err);
      }
      if (!question) {
        return res.status(404).send('Not Found');
      }
      return question.remove(function(err) {
        if (err) {
          return handleError(res, err);
        }
        return res.status(204).send('No Content');
      });
    });
  };

  handleError = function(res, err) {
    return res.send(500, err);
  };

}).call(this);

//# sourceMappingURL=question.controller.js.map
