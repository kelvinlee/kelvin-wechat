// Generated by CoffeeScript 1.7.1

/*
--------------------------------------------
     Begin wechat-process.coffee
--------------------------------------------
 */
var BufferHelper, EventProxy, Segment, checkMessage, checkSignature, config, crypto, formatMessage, fs, getMessage, getParse, go_process, go_subscribe, isEmpty, myProcess, op_Process_list, path, qs, segWord, url, welcometext, xml2js;

op_Process_list = [
  {
    name: "welcome",
    key: "你好",
    type: "text",
    backContent: "你好,好奇的人,欢迎来的桥哥的新奇世界,如果你想自己逛逛就不要理我,如果想听我的介绍,就回复LOVE.",
    next: [
      {
        key: "LOVE",
        type: "text",
        backContent: "你真是个聪明的人,好奇的人,在桥哥的新奇世界里,主要是介绍各种新奇的事、人、物品.",
        next: [
          {
            key: "事",
            type: "text",
            backContent: "看看各种事吧."
          }, {
            key: "人",
            type: "text",
            backContent: "看看各种人吧."
          }, {
            key: "物品",
            type: "image",
            backContent: "看看物品吧."
          }
        ]
      }
    ]
  }, {
    name: "抽奖",
    key: "抽奖",
    type: "text",
    backContent: "点开下面的连接参与抽奖:\n\r http://wechat.giccoo.com/active/nahaoli"
  }, {
    name: "查看抽奖结果",
    key: "查看抽奖结果",
    type: "text",
    backContent: "查看我的抽奖结果:\n\r http://wechat.giccoo.com/active-over/nahaoli"
  }
];

myProcess = false;

go_process = function(msg) {
  var pro, _i, _j, _len, _len1, _ref;
  if (!myProcess) {
    for (_i = 0, _len = op_Process_list.length; _i < _len; _i++) {
      pro = op_Process_list[_i];
      if (pro.key === msg) {
        if (pro.next) {
          myProcess = pro;
        }
        return pro;
        break;
      }
    }
    myProcess = false;
  } else {
    if (myProcess.next) {
      _ref = myProcess.next;
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        pro = _ref[_j];
        if (pro.key === msg) {
          myProcess = pro;
          return pro;
          break;
        }
      }
    }
    go_process(msg);
  }
  return myProcess = false;
};


/*
--------------------------------------------
     Begin wechat-subscribe.coffee
--------------------------------------------
 */

welcometext = {
  name: "welcome",
  key: "你好",
  type: "text",
  backContent: "欢迎关注三星乐园,三星乐园会为您推荐各种好用的软件,好玩的游戏和最新鲜的资讯.以下是近期火热展开的新炫刊活动,点击链接: http://wechat.giccoo.com/lottery/ 即刻参与活动赢取Tab Pro,中奖率百分之百呦,赶快行动吧~"
};

go_subscribe = function(message) {
  return welcometext;
};


/*
--------------------------------------------
     Begin wechat.coffee
--------------------------------------------
 */

fs = require('fs');

path = require('path');

crypto = require('crypto');

xml2js = require('xml2js');

url = require('url');

qs = require('querystring');

BufferHelper = require('bufferhelper');

EventProxy = require('eventproxy');

config = require('../config').config;

Segment = require('segment').Segment;

segWord = new Segment();

segWord.use('URLTokenizer').use('WildcardTokenizer').use('PunctuationTokenizer').use('DictTokenizer').use('ChsNameTokenizer').use('EmailOptimizer').use('ChsNameOptimizer').use('DictOptimizer').use('DatetimeOptimizer').use('ForeignTokenizer').loadDict('dict.txt').loadDict('dict2.txt').loadDict(path.resolve("./dicts/carnames.txt")).loadDict('names.txt').loadDict('wildcard.txt', 'WILDCARD', true);

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
      console.log('声音信息');
      return go_process(message.Recognition);
    case 'video':
      return console.log('视频信息');
    case 'location':
      return console.log('地理信息');
    case 'link':
      return console.log('连接消息');
    case 'event':
      console.log(message.Event);
      if (message.Event === 'subscribe') {
        return go_subscribe(message);
      }
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
    console.log(backMsg, backMsg.type, backMsg.backContent);
    if (backMsg != null) {
      if (backMsg.type === "text") {
        return res.render('wechat-text', {
          toUser: message.FromUserName,
          fromUser: message.ToUserName,
          date: new Date().getTime(),
          content: backMsg.backContent
        });
      }
    } else {
      return res.render('wechat-text', {
        toUser: message.FromUserName,
        fromUser: message.ToUserName,
        date: new Date().getTime(),
        content: ""
      });
    }
  });
};

exports.word = function(req, res, next) {
  var word;
  word = segWord.doSegment("我叫李泓桥,我要预约试驾奥迪SQ5,我想三年之内买车.");
  word.sort(function(a, b) {
    return b.p - a.p;
  });
  console.log(word);
  return res.send("contents");
};
