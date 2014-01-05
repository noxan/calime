path = require 'path'
fs = require 'fs'
formidable = require 'formidable'
config = require '../../config/config'


exports.upload = (req, res) ->
  res.render 'photos/upload', {}


options =
  maxPostSize: 11000000000 # 11 GB
  minFileSize: 1
  maxFileSize: 10000000000 # 10 GB
  acceptFileTypes: /.+/i
  inlineFileTypes: /\.(gif|jpe?g|png)$/i
  imageTypes: /\.(gif|jpe?g|png)$/i
  tempDirectory: '/tmp/'
  uploadDirectory: config.root + 'public/uploads/'

nameCountRegexp = /(?:(?: \(([\d]+)\))?(\.[^.]+))?$/
nameCountFunc = (s, index, ext) ->
  " (" + ((parseInt(index, 10) or 0) + 1) + ")" + (ext or "")


class FileInfo
  constructor: (file) ->
    @name = file.name
    @size = file.size
    @type = file.type
  safeName: () ->
    @name = path.basename(@name).replace /^\.+/, ''
    @name = @name.replace(nameCountRegexp, nameCountFunc)  while fs.existsSync(options.uploadDirectory + "/" + @name)
  validate: () ->
    if options.minFileSize and options.minFileSize > @size
      @error = "File is too small"
    else if options.maxFileSize and options.maxFileSize < @size
      @error = "File is too big"
    else @error = "Filetype not allowed"  unless options.acceptFileTypes.test(@name)
    not @error



exports.uploadPost = (req, res, next) ->
  form = formidable.IncomingForm()
  form.uploadDir = options.tempDirectory

  files = []
  tempFiles = []
  filesMapping = {}

  form.on('fileBegin', (name, file) ->
    tempFiles.push file.path
    fileInfo = new FileInfo(file, req, true)
    fileInfo.safeName()
    filesMapping[path.basename(file.path)] = fileInfo
    files.push fileInfo
  ).on('file', (name, file) ->
    fileInfo = filesMapping[path.basename(file.path)]
    console.log options.uploadDirectory
    fileInfo.size = file.size
    if !fileInfo.validate()
      return fs.unlink file.path

    fs.renameSync file.path, options.uploadDirectory + '/' + fileInfo.name
    console.log fileInfo
  ).on('aborted', () ->
    tempFiles.forEach (file) ->
      fs.unlink(file)
  ).on('end', () ->
    res.writeHead 200, 'application/json'
    res.end JSON.stringify {files: files}
  ).parse(req)
