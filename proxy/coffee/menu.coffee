models = require '../models'
Menu = models.Menu

exports.getMenus = (callback)->
	Menu.find {}, callback

exports.getMenu = (name, callback)->
	Menu.findOne {name: name}, callback

exports.newAndSave = (name, description, url, order, callback)->
	menu = new Menu()
	menu.name = name
	menu.url = url
	menu.order = order
	menu.description = description
	menu.save callback
