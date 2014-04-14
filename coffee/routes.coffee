wechat = require './controllers/wechat'
post = require './controllers/wechat-post'
lottery = require './controllers/lottery'

module.exports = (app)->
  # git never changed.
  # home page
  app.get '/', wechat.index 
  app.post '/', wechat.index 
  app.get '/gettoken', post.gettoken
  app.get '/getmenu', post.getmenu
  app.get '/word', wechat.word

  app.get '/lottery', lottery.index

console.log "routes loaded."