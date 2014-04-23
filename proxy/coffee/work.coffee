models = require '../models'
Work = models.Work

# exports.test = (id,callback)->
#   Work.findById(id).populate('author_id').exec callback
exports.getWorkPage = (pages = 1,size = 20,callback)->
  # console.log (pages-1)*size,size
  skipFrom = (pages-1)*size 
  Work.find({}).sort({create_at:'-1'}).skip(skipFrom).limit(size).populate('author_id').populate('tag_id').exec (err,list)->
    Work.count {},(er,count)->
      callback err,list,count
exports.getWorks = (language, callback)->
  Work.find({}).sort({create_at:'-1'}).populate('author_id').populate('tag_id').exec callback
  #language:language
exports.getWorkByNames = (names, callback)->
	return callback null,[] if names.length is 0
	Work.find {name: names}, callback
exports.getWorkByShortName = (shortname, callback)->
  return callback false,[] if not shortname?
  Work.findOne({shortname: shortname}).populate('author_id').populate('tag_id').exec callback
exports.getWorkByTagId = (id, callback)->
  Work.find {tag_id:id}, callback
exports.getWorkById = (id, callback)->
	# Work.findOne {_id:id}, callback 
  Work.findOne({_id:id}).populate('author_id').populate('tag_id').exec callback
exports.getWorksByQuery = (query, opt, callback)->
	Work.find query, null, opt, callback
exports.delWork = (id,callback)->
  Work.findById id,(err,obj)->
    obj.remove callback
exports.newAndSave = (shortname, title, content, author_id, language, tag_id, mobile, website, img, phonemodel, smallimg, callback)->
  work = new Work()
  work.shortname = shortname
  work.title = title
  work.content = content
  work.author_id = author_id
  work.language = language
  work.tag_id = tag_id
  work.mobile = mobile
  work.website = website
  work.small_img = smallimg
  work.phone_model = phonemodel
  work.img = img
  work.save callback