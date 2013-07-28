noflo = require 'noflo'
chai = require 'chai' unless chai
NormalizeAuthor = require '../components/NormalizeAuthor.coffee'

describe 'NormalizeAuthor component', ->
  c = null
  ins = null
  out = null
  beforeEach ->
    c = NormalizeAuthor.getComponent()
    ins = noflo.internalSocket.createSocket()
    out = noflo.internalSocket.createSocket()
    c.inPorts.in.attach ins
    c.outPorts.out.attach out

  describe 'for author object', ->
    inComing =
      name: 'Henri Bergius'
      email: 'henri.bergius@iki.fi'
    outGoing =
      name: 'Henri Bergius'
      email: 'henri.bergius@iki.fi'
    it 'it should return valid object', (done) ->
      out.on 'data', (author) ->
        chai.expect(author).to.eql outGoing
        done()
      ins.send inComing

  describe 'for author string', ->
    inComing = 'Henri Bergius <henri.bergius@iki.fi>'
    outGoing =
      name: 'Henri Bergius'
      email: 'henri.bergius@iki.fi'
    it 'it should return valid object', (done) ->
      out.on 'data', (author) ->
        chai.expect(author).to.eql outGoing
        done()
      ins.send inComing
