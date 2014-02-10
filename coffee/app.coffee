# app.js for production
path = require 'path'
express = require 'express'
#var io = require socket.io').listen(server); 
config = require('./config').config
routes = require './routes'
fs = require 'fs'


app = express()
# configuration in all env
app.configure ->
  viewsRoot = path.join __dirname, 'views'
  app.set 'view engine', 'jade'
  app.set 'views', viewsRoot
  app.use express.cookieParser()
  app.use express.session
    secret: config.session_secret
  app.use express.urlencoded()
  app.use express.json()
  # app.use (req,res,next)->
  #   return next() if req.body and req.body.git is 'pull'
  #   app.use express.csrf()
  #   next()
  # app.use (req,res,next)->
  #   res.locals.token = req.session._csrf
  #   next()
# app.use (req,res,next)->
#   msgs = req.session.messages || []
#   res.locals.messages = msgs
#   res.locals.hasMessages = !! msgs.length
#   res.locals 
#     messages: msgs
#     hasMessages: !! msgs.length
#   req.session.messages = []
#   console.log req.headers && req.headers["accept-language"]
#   res.locals.config = config
#   language = 'en-US'
#   res.locals.l = require "./language/en-US.js"
#   res.locals.language = language
#   if req.headers && req.headers["accept-language"]
#     language = req.headers["accept-language"].split "," if req.headers["accept-language"]
#     fs.exists "./language/"+language[0]+".js", (exists)->
#       if exists
#         res.locals.l = require "./language/"+language[0]
#         res.locals.language = language[0]
#   next()


# 缓存过期时间
maxAge = 3600000 * 24 * 30
staticDir = path.join __dirname, 'public'

app.configure 'development' ,->
  app.use express.static staticDir
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', ->
  app.use express.static staticDir,
    maxAge: maxAge
  app.set 'view cache', true


routes(app)

app.listen config.port,config.ip

# io.sockets.on '' 

console.log "Giccoo WeChat start."