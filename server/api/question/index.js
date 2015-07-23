(function() {
  'use strict';
  var controller, express, router;

  express = require('express');

  controller = require('./question.controller');

  router = express.Router();

  router.get('/', controller.index);

  router.get('/:id', controller.show);

  router.post('/', controller.create);

  router.put('/:id', controller.update);

  router.patch('/:id', controller.update);

  router["delete"]('/:id', controller.destroy);

  router.post('/:id/answer', controller.createAnswer);

  router.post('/:id/commentAnswer', controller.commentAnswer);

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map
