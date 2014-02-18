wechat = require './controllers/wechat'
post = require './controllers/wechat-post'

module.exports = (app)->
  # git never changed.
  # home page
  app.get '/', wechat.index 
  app.post '/', wechat.index 
  app.get '/gettoken', post.gettoken
  app.get '/getmenu', post.getmenu
  app.get '/word', wechat.word

console.log "routes loaded."