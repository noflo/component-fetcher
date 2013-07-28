noflo = require 'noflo'

class NormalizeAuthor extends noflo.Component
  constructor: ->
    @fallback = 'henri.bergius+noflo@gmail.com'
    @inPorts =
      in: new noflo.Port 'all'
      email: new noflo.Port 'string'
    @outPorts =
      out: new noflo.Port 'object'

    @inPorts.email.on 'data', (data) =>
      @fallback = data

    @inPorts.in.on 'begingroup', (group) =>
      @outPorts.out.beginGroup group
    @inPorts.in.on 'data', (data) =>
      if typeof data is 'string'
        matched = data.match(/(.*) <(.*)>/)
        unless matched
          matched = [data, data, @fallback]
        data =
          name: matched[1]
          email: matched[2]
      data.email = @fallback unless data.email
      @outPorts.out.send data
    @inPorts.in.on 'endgroup', =>
      @outPorts.out.endGroup()
    @inPorts.in.on 'disconnect', =>
      @outPorts.out.disconnect()

exports.getComponent = -> new NormalizeAuthor
