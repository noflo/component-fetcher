chai = require 'chai'
noflo = require 'noflo'

prepareGraph = (receiver, callback) ->
  socket = noflo.internalSocket.createSocket()
  graph = new noflo.Graph 'PrepareComponents'
  graph.addNode 'Prepare', 'componentfetcher/PrepareComponents'
  graph.addNode 'Receive', 'Callback'
  graph.addEdge 'Prepare', 'component', 'Receive', 'in'
  graph.addInitial receiver, 'Receive', 'callback'
  noflo.createNetwork graph, (network) ->
    process.nextTick ->
      send = network.getNode 'Prepare'
      send.component.inPorts.components.attach socket
      callback socket, network

describe 'PrepareComponents graph', ->
  describe 'with a single component as input', ->
    it 'should produce an object for that component', (done) ->
      prepareGraph (component) ->
        chai.expect(component).to.be.an 'object'
        chai.expect(component).to.eql
          title: 'Bar'
          library: 'foo'
        done()
      , (socket) ->
        socket.beginGroup 'foo'
        socket.send
          Bar: './Baz.coffee'
        socket.endGroup()
        socket.disconnect()
  describe 'with a multiple components as input', ->
    it 'should produce an object for each component', (done) ->
      expected = [
        title: 'Bar'
        library: 'foo'
      ,
        title: 'Foo'
        library: 'foo'
      ,
        title: 'Baz'
        library: 'foo'
      ]
      prepareGraph (component) ->
        chai.expect(component).to.be.an 'object'
        chai.expect(component).to.eql expected.shift()
        done() if expected.length is 0
      , (socket, network) ->
        socket.beginGroup 'foo'
        socket.send
          Bar: './Bar.coffee'
          Foo: './Foo.coffee'
          Baz: './Baz.coffee'
        socket.endGroup()
        socket.disconnect()
  describe 'with a multiple libraries as input', ->
    it 'should produce an object for each component', (done) ->
      expected = [
        package: 'foo'
        components: [
          title: 'Bar'
          library: 'foo'
        ,
          title: 'Foo'
          library: 'foo'
        ,
          title: 'Baz'
          library: 'foo'
        ]
      ,
        package: 'bar'
        components: [
          title: 'Alpha'
          library: 'bar'
        ,
          title: 'Bravo'
          library: 'bar'
        ,
          title: 'Charlie'
          library: 'bar'
        ]
      ]
      prepareGraph (component) ->
        chai.expect(component).to.be.an 'object'
        for lib in expected
          continue unless lib.package is component.library
          chai.expect(component).to.eql lib.components.shift()
        remaining = 0
        for lib in expected
          remaining += lib.components.length
        done() if remaining is 0
      , (socket, network) ->
        expected.forEach (lib) ->
          socket.beginGroup lib.package
          comps = {}
          for comp in lib.components
            comps[comp.title] = "components/#{comp.title}.coffee"
          socket.send comps
          socket.endGroup()
          socket.disconnect()
