// Generated by CoffeeScript 1.6.3
var wechat;

wechat = require('./controllers/wechat');

module.exports = function(app) {
  return app.get('/', wechat.index);
};

console.log("routes loaded.");