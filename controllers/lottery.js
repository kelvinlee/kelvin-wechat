// Generated by CoffeeScript 1.7.1
var ACCESS_TOKEN_URL, APPID, EventProxy, REDIRECT_URI, SECRET, STATE, Segment, config, fs, scope, xml2js;

fs = require('fs');

xml2js = require('xml2js');

EventProxy = require('eventproxy');

config = require('../config').config;

Segment = require('segment').Segment;

APPID = config.APPID;

SECRET = config.SECRET;

REDIRECT_URI = config.REDIRECT_URI;

STATE = "ok";

scope = "snsapi_base";

exports.index = function(req, res, next) {
  var code;
  code = req.body.code;
  if (code != null) {
    return res.render('lottery');
  } else {
    return res.redirect('https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + APPID + '&redirect_uri=' + REDIRECT_URI + '&response_type=code&scope=' + scope + '&state=' + STATE + '#wechat_redirect');
  }
};

ACCESS_TOKEN_URL = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + APPID + "&secret=" + SECRET + "&code={code}&grant_type=authorization_code";

exports.work = function(req, res, next) {
  console.log(req.query);
  return res.render('lottery');
};
