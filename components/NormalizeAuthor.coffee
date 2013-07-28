noflo = require 'noflo'

class NormalizeAuthor extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port 'all'
    @outPorts =
      out: new noflo.Port 'object'

    @inPorts.in.on 'begingroup', (group) =>
      @outPorts.out.beginGroup group
    @inPorts.in.on 'data', (data) =>
      if typeof data is 'string'
        matched = data.match(/(.*) <(.*)>/)
        data =
          name: matched[1]
          email: matched[2]
      @outPorts.out.send data
    @inPorts.in.on 'endgroup', =>
      @outPorts.out.endGroup()
    @inPorts.in.on 'disconnect', =>
      @outPorts.out.disconnect()

exports.getComponent = -> new NormalizeAuthor
