requiredProcessEnv = (name) ->
  if !process.env[name]
    throw new Error('You must set the ' + name + ' environment variable')
  process.env[name]

'use strict'

path = require('path')
_ = require('lodash')

# All configurations will extend these options
# ============================================

all =
  env: process.env.NODE_ENV
  root: path.normalize(__dirname + '/../../..')
  port: process.env.PORT or 9000
  seedDB: false
  secrets: session: process.env.SESSION_SECRET or 'graducate-secret'
  userRoles: [
    'guest'
    'user'
    'admin'
  ]
  mongo: options: db: safe: true

# Export the config object based on the NODE_ENV
# ==============================================

module.exports = _.merge(all, require('./' + process.env.NODE_ENV + '.js') or {})
