
/**
 * Populate DB with sample data on server start
 * to disable, edit config/environment/index.js, and set `seedDB: false`
 */

(function() {
  'use strict';
  var Question, Thing, User;

  Thing = require('../api/thing/thing.model');

  User = require('../api/user/user.model');

  Question = require('../api/question/question.model');

  Thing.find({}).remove(function() {
    return Thing.create({
      name: 'Development Tools',
      info: 'Integration with popular tools such as Bower, Grunt, Karma, Mocha, JSHint, Node Inspector, Livereload, Protractor, Jade, Stylus, Sass, CoffeeScript, and Less.'
    }, {
      name: 'Server and Client integration',
      info: 'Built with a powerful and fun stack: MongoDB, Express, AngularJS, and Node.'
    }, {
      name: 'Smart Build System',
      info: 'Build system ignores `spec` files, allowing you to keep tests alongside code. Automatic injection of scripts and styles into your index.html'
    }, {
      name: 'Modular Structure',
      info: 'Best practice client and server structures allow for more code reusability and maximum scalability'
    }, {
      name: 'Optimized Build',
      info: 'Build process packs up your templates as a single JavaScript payload, minifies your scripts/css/images, and rewrites asset names for caching.'
    }, {
      name: 'Deployment Ready',
      info: 'Easily deploy your app to Heroku or Openshift with the heroku and openshift subgenerators'
    });
  });

  User.find({}).remove(function() {
    return User.create({
      provider: 'local',
      firstName: 'Test',
      lastName: 'User',
      email: 'test@test.com',
      password: 'test'
    }, {
      provider: 'local',
      role: 'admin',
      firstName: 'Admin',
      lastName: 'User',
      email: 'admin@admin.com',
      password: 'admin'
    }, function() {
      return console.log('finished populating users');
    });
  });

  Question.find({}).remove(function() {
    return Question.create({
      title: "Question 1",
      body: "This is an example question.",
      answers: [
        {
          body: "This is an answer to the asked question",
          comments: [
            {
              body: "Finally a comment to the answer"
            }
          ]
        }
      ]
    }, {
      title: "Question 2",
      body: "This is a second example question.",
      answers: [
        {
          body: "This is an answer to the asked question",
          comments: [
            {
              body: "Finally a comment to the answer"
            }
          ]
        }
      ]
    }, function() {
      return console.log("Finished populating questions");
    });
  });

}).call(this);

//# sourceMappingURL=seed.js.map
