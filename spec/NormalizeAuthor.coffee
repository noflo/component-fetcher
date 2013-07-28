noflo = require 'noflo'
chai = require 'chai' unless chai
NormalizeAuthor = require '../components/NormalizeAuthor.coffee'

describe 'NormalizeAuthor component', ->
  c = null
  ins = null
  email = null
  out = null
  beforeEach ->
    c = NormalizeAuthor.getComponent()
    ins = noflo.internalSocket.createSocket()
    email = noflo.internalSocket.createSocket()
    out = noflo.internalSocket.createSocket()
    c.inPorts.in.attach ins
    c.inPorts.email.attach email
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

  describe 'for author object without email', ->
    inComing =
      name: 'Henri Bergius'
    outGoing =
      name: 'Henri Bergius'
      email: 'foo@bar.com'
    it 'it should return valid object with given fallback', (done) ->
      out.on 'data', (author) ->
        chai.expect(author).to.eql outGoing
        done()
      email.send 'foo@bar.com'
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

  describe 'for author string without email', ->
    inComing = 'Henri Bergius'
    outGoing =
      name: 'Henri Bergius'
      email: 'foo@bar.com'
    it 'it should return valid object with given fallback', (done) ->
      out.on 'data', (author) ->
        chai.expect(author).to.eql outGoing
        done()
      email.send 'foo@bar.com'
      ins.send inComing
