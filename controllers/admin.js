// Generated by CoffeeScript 1.7.1
var Admin, EventProxy, Lottery, Ut, config, fs, path, randomStr, url;

Admin = require('../proxy').Admin;

Lottery = require('../proxy').Lottery;

fs = require('fs');

path = require('path');

url = require('url');

Ut = require('../lib/util');

EventProxy = require('eventproxy');

config = require('../config').config;

exports.before = function(req, res, next) {
  if (req.session.is_admin && req.cookies.user) {
    res.locals.avatar = Ut.avatar(req.session.email, 26);
    res.locals.username = req.session.username;
    res.locals.userid = req.session.userid;
    next();
  } else {
    res.redirect('/sign/in');
  }
  return false;
};

randomStr = ['giccoo', 'samsung', 'kelvin', 'galaxy s5', 'bob', 'testforsamsung'];

exports.randomCode = function(req, res, next) {
  var randomCode, re;
  re = Ut.recode();
  randomCode = 'sx';
  randomCode += randomStr[Math.round(Math.random() * 5)];
  randomCode += Math.round(Math.random() * 10.);
  randomCode += new Date().getTime();
  randomCode = Ut.md5(randomCode);
  console.log(randomCode);
  return Lottery.create(randomCode, function(err, obj) {
    re.reason = obj.randomcode;
    return res.send(re);
  });
};

exports.homepage = function(req, res, next) {
  return res.render('admin/homepage', {
    sharecontent: config.sharecontent
  });
};

exports.question = function(req, res, next) {
  return res.render('admin/question');
};

exports.signin = function(req, res, next) {
  return res.render('admin/admin-login');
};

exports.signpost = function(req, res, next) {
  var name, passwd, re;
  name = Ut.strim(req.body.username);
  passwd = Ut.strim(req.body.password);
  re = Ut.recode();
  if (Ut.empty(passwd)) {
    re.reason = 'empty password';
    re.recode = 201;
  }
  if (Ut.empty(name)) {
    re.reason = 'empty username';
    re.recode = 201;
  }
  if (re.recode === 200) {
    Admin.getUserLogin(name, passwd, function(err, obj) {
      var day, user;
      if (err) {
        console.log(err);
        re.reason = 'empty username';
        re.recode = 201;
      } else {
        if (obj != null) {
          user = Ut.encrypt(obj._id + '\t' + obj.name, 'giccoo');
          day = 1000 * 60 * 60 * 24 * 7;
          res.cookie('user', user, {
            expires: new Date(Date.now() + 60 * 60 * 24 * 7, {
              maxAge: day
            })
          });
          req.session.is_admin = true;
        } else {
          re.reason = 'none';
          re.recode = 201;
        }
      }
      return res.send(re);
    });
    return false;
  } else {
    return res.send(re);
  }
};
