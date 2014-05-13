wechat = require './controllers/wechat'
post = require './controllers/wechat-post'
lottery = require './controllers/lottery'
lot = require './controllers/lot'
admin = require './controllers/admin'

module.exports = (app)->
  # git never changed.
  # home page
  app.get '/', wechat.index 
  app.post '/', wechat.index 
  app.get '/lottery', lottery.index
  app.post '/lotttery-work', lottery.saveCM
  app.post '/lottery', lottery.lotteryCode

  # app.get '/lot/:lot', lot.lot
  # app.post '/lot/:lot', lot.lot_post


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