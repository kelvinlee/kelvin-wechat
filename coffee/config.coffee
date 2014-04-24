exports.config = 
	debug: true
	name: 'Giccoo-WeChat'
	description: 'WeChat'
	version: '0.1.0' 

	db: 'mongodb://localhost/wechat'
	session_secret: 'giccoo_wechat'
	auth_cookie_name: 'giccoo_wechat'
	ip: '127.0.0.1' #
	port: 8081
	list_count: 20
	host_url: "http://samsung.4view.cn"

	sharecontent: "感谢您参与三星乐园抽奖活动,点击此地址参加抽奖,祝您好运 http://samsung.4view.cn/lottery/?code="

	wechat_token: "kelvinbuild"
	APPID: 'wx86b8da13792d7a54'
	SECRET: "f93ec247a40c59eccbf4bc8b5ac5721c"
	REDIRECT_URI : "http://samsung.4view.cn/lottery-work"
	plugins: [] 