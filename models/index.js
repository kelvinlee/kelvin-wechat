// Generated by CoffeeScript 1.7.1
var config, mongoose;

mongoose = require('mongoose');

config = require('../config').config;

mongoose.connect(config.db, function(err) {
  if (err) {
    console.error('Connect to %s error: ', config.db, err.message);
    return process.exit(1);
  }
});

require('./user');

require('./msg');

exports.User = mongoose.model('User');

exports.Message = mongoose.model('Msg');
