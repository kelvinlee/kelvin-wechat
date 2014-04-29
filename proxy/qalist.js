// Generated by CoffeeScript 1.7.1
var QAlist, models;

models = require('../models');

QAlist = models.QAlist;

exports.checkhas = function(openid, callback) {
  return QAlist.findOne({
    openid: openid
  }, null, {
    sort: {
      create_at: 1
    }
  }, callback);
};

exports.getall = function(callback) {
  return QAlist.find({}, callback);
};

exports.saveNew = function(openid, callback) {
  var qa;
  qa = new QAlist();
  qa.openid = openid;
  return qa.save(callback);
};
