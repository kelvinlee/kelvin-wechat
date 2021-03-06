mongoose = require('mongoose')
config = require('../config').config

mongoose.connect config.db, (err)->
  if err
    console.error('Connect to %s error: ', config.db, err.message) 
    process.exit(1) 

require('./user')
require('./msg')
require('./lottery')
require('./lottery_x_list')
require('./qalist')
require('./onetwo')
require('./admin')

exports.User = mongoose.model 'User'
exports.Message = mongoose.model 'Msg'
exports.Lottery = mongoose.model 'Lottery'
exports.Lottery_x_list = mongoose.model 'Lottery_x_list'
exports.Admin = mongoose.model 'Admin'
exports.QAlist = mongoose.model 'QAlist'
exports.OneTwo = mongoose.model 'OneTwo'