Methods
===========
About
-----
This script demonstartes how to add methods to a nail class.
It is written in literate coffee script and can be run as a nodeunit test.

Setup
-----

    nail = require '../lib/nail.js'
    module.exports.basics = {}

Creating Methods:
-----------------
The followingcode will create a class with the method `hello()`.

    module.exports.basics.methods =
      "setUp": (done) ->
        @classes = {} #serves as class container
        nail.to @classes, 'nail.example', MyClass:
          methods:
            hello: -> 'hello world'
        @instance = new @classes.MyClass()
        done()

      "calling a method": (test) ->
        test.expect 1
        test.equal @instance.hello(), 'hello world'
        test.done()

Oveloading:
-----------
`nail-methods` allow method [overloading][method_overloading.coffe.md]