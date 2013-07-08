nail = require('../lib/nail.js')

exports['package'] =
  setUp: (done) ->
    @classes = {}
    nail.to @classes, 'myNamespace', ParentClass:
      properties:
        name: 'anon'
        age: 42
      methods:
        hello: () -> "hello"
        override: -> "imaparent"
        overload: -> 0
        partialOverride: -> "bye #{@name()}"
    nail.to @classes, 'myNamespace', ChildClass:
      extend: @classes.ParentClass
      properties:
        age: @classes.ParentClass::age()+1
      methods:
        override: -> "imachild"
        overload:
          0: () -> 'no args'
          n: () -> 'args'
        partialOverride:
          0: -> @$parent::partialOverride.call(this)
          n: (name) -> "bye #{name}"

    @instance = new @classes.ParentClass()
    @childInstance = new @classes.ChildClass
    done()

  'proprty combined get/set': (test) ->
    test.expect 2
    test.equal @instance.name(), 'anon'
    @instance.name 'tester'
    test.equal @instance.name(), 'tester'
    test.done()

  'methods': (test) ->
    test.expect 4
    test.equal @instance.hello(), "hello"
    test.equal @instance.override(), "imaparent"
    test.equal @instance.overload(), 0
    test.equal @instance.partialOverride(), 'bye anon'

    test.done()

  'method inheritance': (test) ->
    test.equal @childInstance.hello(), "hello"
    test.done()

  'child overrrides parent': (test) ->
    test.equal @childInstance.override(), "imachild"
    test.equal @childInstance.age(), 43
    test.done()

  'combining override and overload': (test) ->
    test.expect 2
    test.equal @childInstance.overload(), 'no args'
    test.equal @childInstance.overload(1), 'args'
    test.done()

  'partial override': (test) ->
    test.expect 2
    test.equal @childInstance.partialOverride(), @instance.partialOverride()
    test.equal @childInstance.partialOverride('Ben'), 'bye Ben'
    test.done()
