# app.js for production
path = require 'path'
express = require 'express'
#var io = require socket.io').listen(server); 
config = require('./config').config
routes = require './routes'
fs = require 'fs'


app = express()
# configuration in all env
app.use express.bodyParser()
app.configure ->
  viewsRoot = path.join __dirname, 'views'
  app.set 'view engine', 'jade'
  app.set 'views', viewsRoot
  app.use express.cookieParser()
  app.use express.session
    secret: config.session_secret
  app.use express.urlencoded()
  app.use express.json()
  

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