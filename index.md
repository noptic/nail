About
=====
Nail is a cutomizable, framework-independent tool for js/coffee class creation.

Every aspect of the class (properties, methods, inhitence) is handled by an
independent module.

All modules (incuding the core) can be replaced.

Creating your custom version of nail is easy:

    module.exports = require('nail-core').use(
        require 'nail-extend'
        require 'nail-properties'
        require 'nail-methods'
        require './my/awesome/module.js'
    )

This package contains the most common modules ('nail-extend','nail-properties', 'nail-methods')

Features
--------
 - properties with combined setter getter method
 - methods with overload support
 - classic inheritance (prototype chain)
 - classes are added to a container (for example moduele.exports)
 - classes have a fully qualified name

Documentation
-------------
You can find in depth descriptions on the features in the [docs](../../tree/master/docs) directory.

Example
-------
Let us define some classes:

    nail = require('nail')
    nail.to exports, 'myPakage', MyParent:
        methods:
            init: (properties) ->
                for name,value of properties
                    @[name] value
            hello: -> 'hello'

    nail.to exports, 'myPackage', MyChild:
        extend: exports.MyParent
        prperties:
            name:   'anon'
        methods:
            hello:
                0: -> @hello(@name)"
                n: (otherName) -> "hello #{name}"

    bob = new exports.Mychild(name: 'Bob')
    bob.hello() #"hello Bob"
    bob.name 'Holy Bob'
    bob.hello() #"hello Holly Bob"
    bob.hello('stranger') #"hello stranger"
</section><section>
Properties
===========
About
-----
This script demonstartes how to add properties to a nail class.
It is written in literate coffee script and can be run as a nodeunit test.

Setup
-----

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
The value of `foo` is stored in `_foo`. When calling the function `foo`

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
</section><section>
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
Nail supprts method overloading. One can provide different implementations,
for different numbers of arguments
 .
The following code will return 'hello world' if no argument is passed.
If we pass 'sweety' as the first argument it will return 'hello sweety'.

Instead of using a function to implement `hello` we simply use an object whith the
number of arguments as proerty names and functions as a values.

    module.exports.basics.overload =
      "setUp": (done) ->
        @classes = {} #serves as class container
        nail.to @classes, 'nail.example', MyOverloadClass:
          methods:
            hello:
                0:-> 'hello world'
                1:(name)-> "hello #{name}"

        @instance = new @classes.MyOverloadClass()
        done()

      "calling a overloaded method": (test) ->
        test.expect 2
        test.equal @instance.hello(), 'hello world'
        test.equal @instance.hello('sweety'), 'hello sweety'
        test.done()

Strict Argument Number
----------------------

Calling `hello` with 2 or more arguments will cause an error because we only have
implementations taking 1 or 0 arguments.

While it is possible to create overloadsa which accept any numbers of arguments
(as descibed in the next section) we can use
these strict rules to create methods which require a fixed number of arguments.

    module.exports.basics['strict signature'] =
      "setUp": (done) ->
        @classes = {} #serves as class container
        nail.to @classes, 'nail.example', MyStrictClass:
          methods:
            login:2:(name, password) ->
                #do login stuff here
                return true

        @instance = new @classes.MyStrictClass()
        done()

      "calling a strict method": (test) ->
        test.expect 3
        test.ok @instance.login('master', 'bla573r')
        test.throws (()-> @instance.login('master')), Error
        test.throws (()-> @instance.login('master','bla573r','2much')), Error
        test.done()

Default Implemenation
---------------------
To support any number of arguments we can add an default implementtion. If the number of arguments passed to our method
does not match any explicit implementation the `n`implementation will be used.

    module.exports.basics['overload with default'] =
      "setUp": (done) ->
        @classes = {} #serves as class container
        nail.to @classes, 'nail.example', MyOverloadWithDefaultClass:
          methods:
            hello:
                0:-> 'hello world'
                n:(name)-> "hello #{name}"

        @instance = new @classes.MyOverloadWithDefaultClass()
        done()

      "calling a overloaded method with default": (test) ->
        test.expect 3
        test.equal @instance.hello(), 'hello world'
        test.equal @instance.hello('sweety'), 'hello sweety'
        test.equal @instance.hello('sweety','rest','is','ignored'), 'hello sweety'
        test.done()