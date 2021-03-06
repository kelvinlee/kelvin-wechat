// Generated by CoffeeScript 1.7.1
var Lottery_x_list, models;

models = require('../models');

Lottery_x_list = models.Lottery_x_list;

exports.getList = function(callback) {
  return Lottery_x_list.findOne({
    used: false
  }, null, {
    sort: {
      create_at: 1
    }
  }, callback);
};

exports.getLottery = function(lot, callback) {
  return Lottery_x_list.findOne({
    used: false,
    lot: lot
  }, null, {
    sort: {
      create_at: 1
    }
  }, callback);
};

exports.create = function(content, lot, callback) {
  lot = new Lottery_x_list();
  lot.content = content;
  lot.lot = lot;
  return lot.save(callback);
};
