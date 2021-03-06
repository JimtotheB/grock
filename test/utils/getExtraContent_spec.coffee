expect = require('chai').expect

path = require 'path'
Buffer = require('buffer').Buffer
_ = require 'lodash'

getExtraContent = require '../../lib/utils/getExtraContent'

describe "Get extra content", ->
  it "should take an array of existing files paths and return the contents", (done) ->
    paths = [
      path.join __dirname, '../tmp/test-css.css'
      path.join __dirname, '../tmp/test-js.js'
    ]

    getExtraContent(paths).then (content) ->
      expect(content).to.be.eql(['body{background: red;}', 'document.write(123);'])
      done()

  it "should be rejected if one of the files couldn't be read", (done) ->
    paths = [
      path.join __dirname, '../tmp/test-css.css'
      path.join __dirname, '../tmp/some-strange-file'
    ]

    getExtraContent(paths).catch (err) ->
      expect(err).to.be.a('string')
      done()

  it "should works fine when paths is a string in case of single file", (done) ->
    paths = path.join __dirname, '../tmp/test-css.css'

    getExtraContent(paths).then (content) ->
      expect(content).to.be.eql(['body{background: red;}'])
      done()

  it "should be resolved with empty content in case of undefined path", (done) ->
    getExtraContent().then (content) ->
      expect(content).to.be.eql([''])
      done()
