// Generated by CoffeeScript 1.7.1

/*
--------------------------------------------
     Begin wechat.coffee
--------------------------------------------
 */
var BufferHelper, EventProxy, Inser_db_img, Inser_db_qauser, Inser_db_text, Message, Segment, User, checkMessage, checkSignature, config, crypto, formatMessage, fs, getMessage, getParse, getQA, go_img_process, go_process, go_subscribe, isEmpty, myProcess, op_Process_img, op_Process_list, overQA, path, qs, searchQA, segWord, tranStr, url, welcometext, xml2js, _nr, _qa;

User = require('../proxy').User;

Message = require('../proxy').Message;

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

checkMessage = function(message, req) {
  switch (message.MsgType) {
    case 'text':
      console.log('文字信息');
      return getQA(message.Content, message.FromUserName);
    case 'image':
      console.log('图片信息');
      return tranStr(message, go_img_process(message.Content));
    case 'voice':
      console.log('声音信息');
      return tranStr(message, go_process(message.Recognition));
    case 'video':
      console.log('视频信息');
      break;
    case 'location':
      console.log('地理信息');
      break;
    case 'link':
      console.log('连接消息');
      break;
    case 'event':
      if (message.Event === 'subscribe') {
        return go_subscribe(message);
      }
      return null;
  }
  return null;
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


/*
--------------------------------------------
     Begin wechat-process.coffee
--------------------------------------------
 */

_nr = "\n\r";

op_Process_list = [
  {
    name: "抽奖",
    key: "抽奖",
    type: "text",
    backContent: "您点不开下面的连接参与抽奖:" + _nr + " " + config.host_url + "/active/test/ 只是测试回复功能"
  }, {
    name: "查看抽奖结果",
    key: "查看抽奖结果",
    type: "text",
    backContent: "查看我的抽奖结果:" + _nr + " " + config.host_url + "/active-over/test"
  }
];

op_Process_img = [
  {
    name: "返回收到图片信息",
    key: "img",
    type: "text",
    backContent: "已经收到您的截图,请等待管理员审核内容,审核通过后会给您发送抽奖地址."
  }
];

go_img_process = function() {
  return op_Process_img[0];
};

myProcess = false;

go_process = function(msg) {
  var pro, _i, _j, _len, _len1, _ref;
  if (!myProcess) {
    for (_i = 0, _len = op_Process_list.length; _i < _len; _i++) {
      pro = op_Process_list[_i];
      if (pro.key === msg) {
        if (pro.next) {
          myProcess = pro;
          if (pro.event != null) {
            pro.event.call();
          }
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
          if (pro.event != null) {
            pro.event.call();
          }
          return pro;
          break;
        }
      }
    }
    go_process(msg);
  }
  return myProcess = false;
};

tranStr = function(message, str) {
  return str;
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
  backContent: "感谢您关注【三星乐园】官⽅方微信,参与《我爱三星视频秀》答题,即有机会获 得丰厚⼤大奖 本期《我爱三星视频秀》正在为您揭秘三星热门旗舰机型——GALAXY S5,关注 直播内容并正确回答以下三个问题,即有机会获得S5九折卡、70M流量卡等超值 奖品,幸运的⼩小伙伴更有机会获得GALAXY S5惊喜⼤大礼!⼼心动不如⾏行动,⼀一起来 答题吧~回复【1】了解活动详情,回复【2】开始答题。"
};

go_subscribe = function(message) {
  return welcometext;
};


/*
--------------------------------------------
     Begin wechat-db-Operating.coffee
--------------------------------------------
 */

Inser_db_text = function(db) {
  return Message.saveText(db.FromUserName, db.MsgType, db.Content, db.MsgId, function(err) {
    return console.log("text back:", err);
  });
};

Inser_db_img = function(db) {
  return Message.saveImg(db.FromUserName, db.MsgType, db.PicUrl, db.MsgId, db.MediaId, function(err) {
    return console.log("text back:", err);
  });
};

Inser_db_qauser = function(db) {
  return console.log(db);
};


/*
--------------------------------------------
     Begin wechat-qa.coffee
--------------------------------------------
 */

_nr = "\n\r";

_qa = [
  {
    name: "查看活动详情",
    key: "1",
    type: "text",
    backContent: "活动详情"
  }, {
    name: "开始答题",
    key: "2",
    type: "text",
    backContent: "节⽬目中特别提到的Gear版特⾊色应⽤用是?" + _nr + "A,搜狐视频Gear版 " + _nr + "B,⾼高德地图Gear版 " + _nr + "C,S健康Gear版",
    next: [
      {
        name: "答案1",
        key: "A",
        type: "text",
        backContent: "很抱歉,本题回答错误。请根据本期《我爱三星视频秀》直播内容,重新作答。"
      }, {
        name: "答案2",
        key: "B",
        type: "text",
        backContent: "很抱歉,本题回答错误。请根据本期《我爱三星视频秀》直播内容,重新作答。"
      }, {
        name: "答案3",
        key: "C",
        type: "text",
        backContent: "⾦金秀贤最喜欢的时尚刊物APP是什么?" + _nr + "A、《宝宝俱乐部》 " + _nr + "B、《新炫刊》" + _nr + "C、《掌阅iReader》",
        next: [
          {
            name: "答案1",
            key: "A",
            type: "text",
            backContent: "很遗憾,回答错误。请再次作答。"
          }, {
            name: "答案2",
            key: "B",
            type: "text",
            backContent: "很遗憾,回答错误。请再次作答。"
          }, {
            name: "答案3",
            key: "C",
            type: "text",
            backContent: "节⽬目中重点介绍了⼀一个钱包类app,可以⽅方便实现各类卡券的收纳与管 理,是以下的哪个?" + _nr + "A、《⽀支付宝钱包》 " + _nr + "B、《壹钱包》 " + _nr + "C、《三星钱包》",
            next: [
              {
                name: "答案1",
                key: "A",
                type: "text",
                backContent: "哎呀,答错了。还有机会哦!"
              }, {
                name: "答案2",
                key: "B",
                type: "text",
                backContent: "哎呀,答错了。还有机会哦!"
              }, {
                name: "答案3",
                key: "C",
                type: "text",
                backContent: "恭喜你全部答对了,已经成功参与抽奖,敬请关注中奖通知.",
                evt: overQA
              }
            ]
          }
        ]
      }
    ]
  }
];

myProcess = [];

getQA = function(message, openid) {
  var key, qa, _n;
  key = message;
  console.log("user " + openid + " :", myProcess[openid]);
  if (myProcess[openid] != null) {
    qa = myProcess[openid].next;
    qa = searchQA(key, qa);
    if (qa.event != null) {
      qa.evt.call(openid);
    }
    if (qa.next != null) {
      myProcess[openid] = qa;
    }
  } else {
    myProcess[openid] = searchQA(key, _qa);
    qa = _n = myProcess[openid];
  }
  return qa;
};

searchQA = function(key, list) {
  var a, _i, _len;
  for (_i = 0, _len = list.length; _i < _len; _i++) {
    a = list[_i];
    if (a.key === key) {
      return a;
    }
  }
};

overQA = function(openid) {
  console.log(openid);
  myProcess[openid] = null;
  return Inser_db_qauser({
    openid: openid
  });
};
