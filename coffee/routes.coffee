wechat = require './controllers/wechat'
post = require './controllers/wechat-post'
lottery = require './controllers/lottery'
admin = require './controllers/admin'

module.exports = (app)->
  # git never changed.
  # home page
  app.get '/', wechat.index 
  app.post '/', wechat.index 
  app.get '/lottery', lottery.index
  app.get '/lottery-work', lottery.work
  app.post '/lottery', lottery.lotteryCode


  app.get '/gettoken', post.gettoken
  app.get '/getmenu', post.getmenu
  app.get '/word', wechat.word

  # 管理
  app.get '/admin/*', admin.before
  app.get '/sign/in', admin.signin
  app.post '/sign/in', admin.signpost
  app.get '/admin/homepage', admin.homepage
  app.post '/admin/random', admin.randomCode

console.log "routes loaded."