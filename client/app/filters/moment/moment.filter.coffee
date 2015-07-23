'use strict'

angular.module 'graducateApp'
.filter 'moment', ->
  (input, format) ->
    moment(input).format(format)
