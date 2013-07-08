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