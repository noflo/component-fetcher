noflo = require 'noflo'
path = require 'path'

class BuildFilename extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port
    @outPorts =
      out: new noflo.Port

    @inPorts.in.on 'data', (component) =>
      @outPorts.out.send "2013-07-12-#{component.library}-#{component.title}.md"
      @outPorts.out.disconnect()

exports.getComponent = -> new BuildFilename
