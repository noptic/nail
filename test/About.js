var dalia, nail, should, _;

nail = require('../coverage/instrument/lib/module.js');

should = require('should');

_ = require('underscore');

nail.to(exports, 'my-module', {
  Person: {
    fields: {
      firstName: null,
      lastName: null
    },
    properties: {
      fullName: {
        get: function() {
          return "" + this.lastName + ", " + this.firstName;
        }
      }
    },
    methods: {
      greet: function() {
        return "hello, " + this.fullName;
      }
    }
  }
});

describe('Person', function() {
  return it('is a function', function() {
    return (_.isFunction(exports.Person)).should.be.ok;
  });
});

dalia = new exports.Person({
  firstName: 'Dalia',
  lastName: 'Scarlet'
});

it('injects data', function() {
  dalia.firstName.should.equal('Dalia');
  return dalia.lastName.should.equal('Scarlet');
});

it('creates properties', function() {
  return dalia.fullName.should.equal('Scarlet, Dalia');
});

it('creates methods', function() {
  return dalia.greet().should.equal('hello, Scarlet, Dalia');
});

it("can be loaded from json", function() {
  var loadObject, nick, sampleJSON;
  sampleJSON = "{\n  \"type\": \"my-module.Person\",\n  \"properties\":{\n    \"firstName\": \"Nick\",\n    \"lastName\":  \"Pudel\"\n  }\n}";
  loadObject = function(data) {
    return new nail.lib[data.type](data.properties);
  };
  nick = loadObject(JSON.parse(sampleJSON));
  nick.firstName.should.equal('Nick');
  nick.lastName.should.equal('Pudel');
  return nick.fullName.should.equal("Pudel, Nick");
});
