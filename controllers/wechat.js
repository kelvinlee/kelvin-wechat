// Generated by CoffeeScript 1.7.1

/*
--------------------------------------------
     Begin wechat.coffee
--------------------------------------------
 */
var BufferHelper, EventProxy, Inser_db_img, Inser_db_text, Message, Segment, User, checkMessage, checkSignature, config, crypto, formatMessage, fs, getMessage, getParse, go_img_process, go_process, go_subscribe, isEmpty, myProcess, op_Process_img, op_Process_list, path, qs, segWord, tranStr, url, welcometext, xml2js, _nr;

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

checkMessage = function(message) {
  console.log(message.MsgType);
  switch (message.MsgType) {
    case 'text':
      console.log('文字信息');
      Inser_db_text(message);
      return tranStr(message, go_process(message.Content));
    case 'image':
      console.log('图片信息');
      Inser_db_img(message);
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
      console.log(message.Event);
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
  }, {
    name: "答题回答问题",
    key: "开始答题",
    type: "text",
    backContent: "第一题:三星 galayxy S5 的后置摄像头是多少像素" + _nr + " A. 500万" + _nr + "B. 1000万" + _nr + "C. 1500万",
    next: [
      {
        name: "答案1",
        key: "A",
        backContent: "答得不对哦,再试试其他的答案"
      }, {
        name: "答案2",
        key: "B",
        backContent: "答得不对哦,再试试其他的答案"
      }, {
        name: "答案3",
        key: "C",
        backContent: "恭喜答对了" + _nr + "第二题:三星 galayxt S5 使用的是几核CPU?" + _nr + "A. 双核" + _nr + "B. 四核" + _nr + "C. 八核",
        next: [
          {
            name: "答案1",
            key: "A",
            backContent: "再仔细想想看"
          }, {
            name: "答案2",
            key: "B",
            backContent: "再仔细想想看"
          }, {
            name: "答案1",
            key: "C",
            backContent: "哎呦,不错哦" + _nr + "第三题:三星 galayxy S5 的新增特色功能是什么?" + _nr + "A. 指纹识别" + _nr + "B. 眼球阅读" + _nr + "C. 电源节省",
            next: [
              {
                name: "答案1",
                key: "A",
                backContent: "干得漂亮,你已经答对了所有的题目,成功参与此次抽奖活动,敬请期待抽奖结果,也可以使用口令'查看抽奖结果',来查看自己的中奖情况",
                event: function() {}
              }, {
                name: "答案2",
                key: "B",
                backContent: "只差一点就答对了."
              }, {
                name: "答案3",
                key: "C",
                backContent: "只差一点就答对了."
              }
            ]
          }
        ]
      }
    ]
  }, {
    name: ""
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
  backContent: "欢迎关注三星乐园,三星乐园会为您推荐各种好用的软件,好玩的游戏和最新鲜的资讯.以下是近期火热展开的新炫刊活动,点击链接: " + config.host_url + "/lottery/ 即刻参与活动赢取Tab Pro,中奖率百分之百呦,赶快行动吧~"
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
