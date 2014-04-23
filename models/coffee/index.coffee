mongoose = require('mongoose')
config = require('../config').config

mongoose.connect config.db, (err)->
  if err
    console.error('Connect to %s error: ', config.db, err.message) 
    process.exit(1) 

require('./user')
require('./msg')

exports.User = mongoose.model 'User'
exports.Message = mongoose.model 'Msg'