// Generated by CoffeeScript 1.6.3
var post, wechat;

wechat = require('./controllers/wechat');

post = require('./controllers/wechat-post');

module.exports = function(app) {
  app.get('/', wechat.index);
  app.post('/', wechat.index);
  app.get('/gettoken', post.gettoken);
  app.get('/getmenu', post.getmenu);
  return app.get('/word', wechat.word);
};

console.log("routes loaded.");
