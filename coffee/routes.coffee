wechat = require './controllers/wechat'

module.exports = (app)->
  # git never changed.
  # home page
  app.get '/', wechat.index 
  app.post '/', wechat.index 

console.log "routes loaded."