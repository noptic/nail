Method Overloading
==================
About
-----
This script demonstartes how to overload methods in a nail class.
It is written in literate coffee script and is compiled into a [test](../test/method_overloading_generated_test.js).

Setup
-----

    nail = require '../lib/nail.js'
    module.exports.basics = {}

Explicit Overloading
--------------------
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







