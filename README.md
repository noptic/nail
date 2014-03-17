
[glob]: https://npmjs.org/package/glob
[grunt-contrib-coffee]: https://github.com/gruntjs/grunt-contrib-coffee
[grunt-istanbul-coverage]: https://github.com/daniellmb/grunt-istanbul-coverage
[grunt-istanbul]: https://github.com/taichi/grunt-istanbul
[grunt-simple-mocha]: https://github.com/yaymukund/grunt-simple-mocha
[grunt]: http://gruntjs.com/
[install]: http://github.com/benjamn/install
[mocha]: https://npmjs.org/package/mocha
[nail-common]: https://npmjs.org/package/nail-common
[nail-core]: https://github.com/noptic/nail-core
[npm]: https://npmjs.org/doc/
[should]: https://github.com/visionmedia/should.js
[underscore]: http://underscorejs.org


[About]: spec\About.coffee.md

nail - simple modular classes
=============================
Nail is a simple but flexble tool for creating coffe/java script classes.

Nail uses the powefull [nail-core] API to handlethe propertiesmethods and
iheritance with seperate replacable modules.

Class definitions in nail are well strcutured and tool friendly.

This Document
=============
To ensure that the examle code is up to date it is run as a test-
This requires [underscore], [should] and an instrumented version of nail.
In your productive code `nail = require 'nail'` should be enough.

    nail    = require '../coverage/instrument/lib/module.js'
    should  = require 'should'
    _       = require 'underscore'

Overview
========
The nail concept:

 - class definitions are objects
 - every key in the definition is a class
 - every aspect of a class has a seperate block

Nail uses the API defined by [nail-core] and modules from [nail-common].

Usage
=====
###Creating a class
The following code defines the class `Person` and adds it to exports and the
namespace 'my-module'.

    nail.to exports, 'my-module', Person:
      fields:
        firstName:  null
        lastName:   null
      properties:
        fullName:
          get:-> "#{@lastName}, #{@firstName}"
      methods:
        greet: -> return "hello, #{@fullName}"

Now our package exports the constructor for Person.

    describe 'Person', ->
      it 'is a function', ->
        (_.isFunction exports.Person).should.be.ok

###creating an instance
Values are injected into the new Instance.

    dalia = new exports.Person
      firstName: 'Dalia'
      lastName:  'Scarlet'
    it 'injects data', ->
      dalia.firstName.should.equal 'Dalia'
      dalia.lastName.should.equal  'Scarlet'
    it 'creates properties', ->
      dalia.fullName.should.equal  'Scarlet, Dalia'
    it 'creates methods', ->
      dalia.greet().should.equal 'hello, Scarlet, Dalia'

###using namespaces
Using namespaces will give every class a unique name.

This simple generic factory functionm creates instance of Person from JSON.

    it "can be loaded from json", ->
      sampleJSON ="""
                  {
                    "type": "my-module.Person",
                    "properties":{
                      "firstName": "Nick",
                      "lastName":  "Pudel"
                    }
                  }
                """
      loadObject = (data) -> new nail.lib[data.type] data.properties

      nick  = loadObject(JSON.parse sampleJSON)
      nick.firstName.should.equal 'Nick'
      nick.lastName.should.equal 'Pudel'
      nick.fullName.should.equal "Pudel, Nick"

##Setup
Install with npm:
```bash
npm install nail
```

Clone with GIT:
```bash
git clone https://github.com/noptic/nail.git
```

##Documentation
Head here → [docs](docs)

##Dependencies
 - [nail-common] 0.1.0-alpha4
 - [install] ~0.1.7
 - [npm] ~1.3.11
 - [underscore] ~1.5.2
 - [nail-core] 0.1.0-beta3

##DevDependencies
 - [grunt-contrib-coffee] 0.7.0
 - [grunt] 0.4.1
 - [grunt-simple-mocha] ~0.4.0
 - [mocha] ~1.12.0
 - [should] ~1.2.2
 - [grunt-istanbul-coverage] 0.0.1
 - [grunt-istanbul] ~0.2.3
 - [glob] ~3.2.6
 - [underscore] ~1.5.2
