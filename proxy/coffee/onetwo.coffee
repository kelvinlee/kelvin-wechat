models = require '../models'
OneTwo = models.OneTwo

exports.getOneTwos = (callback)->
	OneTwo.find {}, callback

exports.getLottery = (openid, backup, callback)->
	console.log "openid:",openid,backup
	OneTwo.findOne {openid: openid}, callback

exports.newAndSave = (openid, lot, callback)->
	one = new OneTwo()
	one.openid = openid
	one.lot = lot
	one.save callback
