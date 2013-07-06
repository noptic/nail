Basic Usage
===========
About
-----
This script demonstartes how to use nail.
It is written in literate coffee and can be run as a nodeunit test.

Setup
-----
First we have to load nail and create a test group:

    nail = require '../lib/nail.js'
    module.exports.basics = {}
    module.exports.basics.properties = {}

Creating Properties
-------------------
The followingcode will create a class with the property `foo`.

    module.exports.basics.properties =
      "setUp": (done) ->
        @classes = {} #serves as class container
        nail.to @classes, 'nail.example', MyClass:
          properties:
            foo:    'bar'
        @instance = new @classes.MyClass()
        done()

Get a Property
--------------
For each property nail will craete a setter/ getter function.
To get the value of `foo` call `foo()` without an argument

    module.exports.basics.properties["get value"] = (test) ->
      test.expect 1
      test.equal @instance.foo(), 'bar',
        "calling foo without arguments return the value of foo"
      test.done()

Set Property
------------
To change a property  we call the same function but pass the new value as first argument.

    module.exports.basics.properties["set value"] = (test) ->
      test.expect 1
      @instance.foo('new value')
      test.equal @instance.foo(), 'new value'
      test.done()

Generic get and set
-------------------
The actual value of `foo` is stored in `_foo`. When calling the function `foo`

    module.exports.basics.properties["helper property"] = (test) ->
      test.expect 1
      @instance.foo('new value')
      test.equal @instance.foo(), @instance._foo
      test.done()

All calls to the setter/getter are handled by the generic methods `get(name)`
and `set(name, value)`. If we change one of those methods we can customize the
behaviour of all get set operations.

In this example we will replace `set` with a dummy so the object can not be changed.

    module.exports.basics.properties["inmutable object"] = (test) ->
      test.expect 1
      @instance.set = ()->
      oldValue = @instance.foo()
      @instance.foo('useless set operation')
      test.equal @instance.foo(), oldValue
      test.done()

By overriding `get`and `set` you can change where the real values are stored or
trigger events whenevr a vlue changes.