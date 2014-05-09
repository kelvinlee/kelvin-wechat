// Generated by CoffeeScript 1.7.1
var ACCESS_TOKEN_URL, APPID, EventProxy, Lottery, Lottery_x_list, REDIRECT_URI, SECRET, STATE, Segment, Ut, config, fanpai, fs, getRandom, scope, sumArr, xml2js, _lotlist;

Lottery = require('../proxy').Lottery;

Lottery_x_list = require('../proxy').Lottery_x_list;

fs = require('fs');

xml2js = require('xml2js');

EventProxy = require('eventproxy');

config = require('../config').config;

Segment = require('segment').Segment;

Ut = require('../lib/util');

APPID = config.APPID;

SECRET = config.SECRET;

REDIRECT_URI = config.REDIRECT_URI;

STATE = "ok";

scope = "snsapi_base";

ACCESS_TOKEN_URL = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + APPID + "&secret=" + SECRET + "&code={code}&grant_type=authorization_code";

sumArr = function(list) {
  var a, r, _i, _len;
  r = 0;
  for (_i = 0, _len = list.length; _i < _len; _i++) {
    a = list[_i];
    r += parseInt(a);
  }
  return r;
};

getRandom = function(min, max) {
  return Math.round(Math.random() * (max - min) + min);
};

_lotlist = ["card", "cm"];

fanpai = function() {
  var $proSum, $randNum, $re, i, lotlist, _i, _ref;
  lotlist = [50, 50];
  $re = '';
  $proSum = sumArr(lotlist);
  for (i = _i = 0, _ref = lotlist.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
    $randNum = getRandom(1, $proSum);
    if ($randNum <= lotlist[i]) {
      $re = i;
      break;
    } else {
      $proSum -= lotlist[i];
    }
  }
  return $re;
};

exports.index = function(req, res, next) {
  var code;
  code = req.query.code;
  return Lottery.getLotter(code, function(err, obj) {
    if ((obj != null) && (obj.lottery != null)) {
      return res.render('lottery', {
        lots: true,
        code: code,
        lot: obj
      });
    } else {
      return res.render('lottery', {
        lots: false,
        code: code,
        lot: {}
      });
    }
  });
};

exports.lotteryCode = function(req, res, next) {
  var code, num, re;
  code = req.body.code;
  num = parseInt(req.body.nums);
  if (num > 3) {
    num = 3;
  }
  if (num < 1) {
    num = 1;
  }
  re = Ut.recode();
  return Lottery.getLotter(code, function(err, obj) {
    var lot;
    if (obj == null) {
      re.recode = 201;
      re.reason = "nocode";
      res.send(re);
      return false;
    }
    if (obj.lottery != null) {
      re.recode = 202;
      re.reason = "already have";
      return res.send(re);
    } else {
      lot = fanpai();
      return Lottery_x_list.getLottery(_lotlist[lot], function(err, lot_obj) {
        if (lot_obj != null) {
          obj.lottery = lot_obj.content;
          obj.num = num;
          obj.lot_at = new Date();
          obj.save();
          lot_obj.used = true;
          lot_obj.usedby = code;
          lot_obj.save();
          return res.send(re);
        } else {
          obj.lottery = "none";
          obj.num = num;
          obj.lot_at = new Date();
          obj.save();
          re.reason = "none";
          return res.send(re);
        }
      });
    }
  });
};

exports.work = function(req, res, next) {
  console.log(req.query);
  return res.render('lottery-work');
};
