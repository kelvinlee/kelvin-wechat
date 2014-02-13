// Generated by CoffeeScript 1.6.3
var BufferHelper, EventProxy, checkMessage, checkSignature, config, crypto, formatMessage, getMessage, getParse, go_process, isEmpty, myProcess, op_Process_list, qs, url, xml2js;

op_Process_list = [
  {
    name: "welcome",
    key: "你好",
    backContent: "你好,好奇的人,欢迎来的桥哥的新奇世界,如果你想自己逛逛就不要理我,如果想听我的介绍,就回复LOVE.",
    next: [
      {
        key: "LOVE",
        backContent: "你真是个聪明的人,好奇的人,在桥哥的新奇世界里,主要是介绍各种新奇的事、人、物品.",
        next: [
          {
            key: "事",
            backContent: "看看各种事吧."
          }, {
            key: "人",
            backContent: "看看各种人吧."
          }, {
            key: "物品",
            backContent: "看看物品吧."
          }
        ]
      }
    ]
  }
];

myProcess = false;

go_process = function(msg) {
  var pro, _i, _j, _len, _len1, _ref;
  if (!myProcess) {
    for (_i = 0, _len = op_Process_list.length; _i < _len; _i++) {
      pro = op_Process_list[_i];
      if (pro.key === msg) {
        myProcess = pro;
        return pro.backContent;
        break;
      }
    }
  } else {
    if (myProcess.next) {
      _ref = myProcess.next;
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        pro = _ref[_j];
        if (pro.key === msg) {
          myProcess = pro;
          return pro.backContent;
          break;
        }
      }
    }
  }
  return myProcess = false;
};


/* --------------------------------------------
     Begin wechat.coffee
--------------------------------------------
*/

crypto = require('crypto');

xml2js = require('xml2js');

url = require('url');

qs = require('querystring');

BufferHelper = require('bufferhelper');

EventProxy = require('eventproxy');

config = require('../config').config;

checkSignature = function(query, token) {
  var arr, nonce, shasum, signature, timestamp;
  signature = query.signature;
  timestamp = query.timestamp;
  nonce = query.nonce;
  shasum = crypto.createHash('sha1');
  arr = [token, timestamp, nonce].sort();
  shasum.update(arr.join(''));
  return shasum.digest('hex') === signature;
};

getParse = function(req) {
  var query;
  query = url.parse(req.url).query;
  return qs.parse(query);
};

isEmpty = function(thing) {
  return typeof thing === "object" && (thing !== null) && Object.keys(thing).length === 0;
};

getMessage = function(stream, callback) {
  var buf;
  buf = new BufferHelper();
  return buf.load(stream, function(err, buf) {
    var xml;
    if (err) {
      return callback(err);
    }
    xml = buf.toString('utf-8');
    return xml2js.parseString(xml, {
      trim: true
    }, callback);
  });
};

formatMessage = function(result) {
  var key, message, val;
  message = {};
  if (!result) {
    return false;
  }
  for (key in result.xml) {
    val = result.xml[key][0];
    message[key] = (isEmpty(val) ? '' : val).trim();
  }
  return message;
};

checkMessage = function(message) {
  console.log(message.MsgType);
  switch (message.MsgType) {
    case 'text':
      console.log('文字信息');
      return go_process(message.Content);
    case 'image':
      return console.log('图片信息');
    case 'voice':
      return console.log('声音信息');
    case 'video':
      return console.log('视频信息');
    case 'location':
      return console.log('地理信息');
    case 'link':
      return console.log('连接消息');
    case 'event':
      return console.log(message.Event);
  }
};

exports.index = function(req, res, next) {
  var parse, to;
  parse = getParse(req);
  to = checkSignature(parse, config.wechat_token);
  return getMessage(req, function(err, result) {
    var backMsg, message;
    if (err) {
      console.log(err);
    }
    message = formatMessage(result);
    if (!message) {
      return res.send(to ? parse.echostr : "what?");
    }
    backMsg = checkMessage(message);
    console.log(message);
    if (backMsg) {
      return res.render('wechat-text', {
        toUser: message.FromUserName,
        fromUser: message.ToUserName,
        date: new Date().getTime(),
        content: backMsg
      });
    }
  });
};
