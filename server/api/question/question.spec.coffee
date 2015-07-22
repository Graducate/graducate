'use strict'

should = require('should')
app = require('../../app')
request = require('supertest')

describe 'GET /api/questions', ->
  it 'should respond with JSON array', (done) ->
    request(app).get('/api/questions').expect(200).expect('Content-Type', /json/).end (err, res) ->
      if err
        return done(err)
      res.body.should.be.instanceof Array
      done()