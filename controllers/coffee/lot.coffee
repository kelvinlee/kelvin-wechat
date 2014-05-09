# 数据库
Lottery = require('../proxy').Lottery
Lottery_x_list = require('../proxy').Lottery_x_list

# 基础类库
fs = require 'fs'
xml2js = require 'xml2js'
EventProxy = require 'eventproxy'
config = require('../config').config
Segment = require('segment').Segment
Ut = require('../lib/util')
	
exports.lot = (req,res,next)->
	# 获取活动进行分发.
	# 
	lot = req.params.lot

	if lot is 'onetwo'
		res.render 'lottery-onetwo'

	

exports.work = (req,res,next)->
	console.log req.query
	res.render 'lottery-work'
