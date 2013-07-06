(function() {
  var nail;

  nail = require('../lib/nail.js');

  module.exports.basics = {};

  module.exports.basics.overload = {
    "setUp": function(done) {
      this.classes = {};
      nail.to(this.classes, 'nail.example', {
        MyOverloadClass: {
          methods: {
            hello: {
              0: function() {
                return 'hello world';
              },
              1: function(name) {
                return "hello " + name;
              }
            }
          }
        }
      });
      this.instance = new this.classes.MyOverloadClass();
      return done();
    },
    "calling a overloaded method": function(test) {
      test.expect(2);
      test.equal(this.instance.hello(), 'hello world');
      test.equal(this.instance.hello('sweety'), 'hello sweety');
      return test.done();
    }
  };

  module.exports.basics['strict signature'] = {
    "setUp": function(done) {
      this.classes = {};
      nail.to(this.classes, 'nail.example', {
        MyStrictClass: {
          methods: {
            login: {
              2: function(name, password) {
                return true;
              }
            }
          }
        }
      });
      this.instance = new this.classes.MyStrictClass();
      return done();
    },
    "calling a strict method": function(test) {
      test.expect(3);
      test.ok(this.instance.login('master', 'bla573r'));
      test.throws((function() {
        return this.instance.login('master');
      }), Error);
      test.throws((function() {
        return this.instance.login('master', 'bla573r', '2much');
      }), Error);
      return test.done();
    }
  };

  module.exports.basics.overload = {
    "setUp": function(done) {
      this.classes = {};
      nail.to(this.classes, 'nail.example', {
        MyOverloadWithDefaultClass: {
          methods: {
            hello: {
              0: function() {
                return 'hello world';
              },
              n: function(name) {
                return "hello " + name;
              }
            }
          }
        }
      });
      this.instance = new this.classes.MyOverloadWithDefaultClass();
      return done();
    },
    "calling a overloaded method with default": function(test) {
      test.expect(3);
      test.equal(this.instance.hello(), 'hello world');
      test.equal(this.instance.hello('sweety'), 'hello sweety');
      test.equal(this.instance.hello('sweety', 'rest', 'is', 'ignored'), 'hello sweety');
      return test.done();
    }
  };

}).call(this);
