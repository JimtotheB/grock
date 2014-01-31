###
# # Write JSON File Tree
###

fs = require 'fs'
path = require 'path'
_ = require 'lodash'

through = require('event-stream').through

log = require '../utils/log'

getTitle = (file) ->
  title = _.find(file.extra?.toc, level: 1)?.title
  if title and title isnt ''
    return title
  return

module.exports = (fileName, opts={}) ->
  unless fileName
    throw new Error("Render File Tree: Missing fileName option")

  filePrefix = opts.filePrefix or "window.#{opts.varName or 'files'} = [\n"
  fileSuffix = opts.fileSuffix or "\n];"

  output = []
  output.push filePrefix
  first = true

  bufferContents = (file, enc, cb) ->
    output.push (if first then '' else ',\n') + JSON.stringify({
      path: file.relative
      originalName: path.basename file.originalPath
      originalPath: file.originalRelative
      name: path.basename file.path
      lang: file.extra?.lang?.highlightJS or file.extra?.lang?.pygmentsLexer
      title: getTitle(file)
      toc: file.extra?.toc
    }, false, 2)
    first = false

    @emit('data', file)

  endStream = (cb) ->
    output.push fileSuffix
    fs.writeFile fileName, output.join(''), (err) =>
      return cb(err) if err
      if opts.verbose
        log "File tree written to #{path.basename fileName}"
      @emit('end')

  through bufferContents, endStream
