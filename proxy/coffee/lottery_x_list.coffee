models = require '../models'
Lottery_x_list = models.Lottery_x_list

exports.getList = (callback)->
	Lottery_x_list.findOne {used:false},null,{sort:{create_at:1}},callback

exports.create = (content,callback)->
	lot = new Lottery_x_list()
	lot.content = content
	lot.save callback
  

