models = require '../models'
Lottery = models.Lottery

exports.getLotter = (code, callback)->
	Lottery.findOne {randomcode:code},null,{sort:{create_at:1}},callback
exports.getLotterByLot = (lot,callback)->
	Lottery.find {lottery:lot},null,{sort:{create_at:1}},callback

exports.create = (randomCode,callback)->
  lot = new Lottery()
  lot.randomcode = randomCode
  lot.save callback

