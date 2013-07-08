(function() {
  var nail;

  nail = require('../lib/nail.js');

  module.exports.basics = {};

  module.exports.basics.properties = {};

  module.exports.basics.properties = {
    "setUp": function(done) {
      this.classes = {};
      nail.to(this.classes, 'nail.example', {
        MyClass: {
          properties: {
            foo: 'bar'
          }
        }
      });
      this.instance = new this.classes.MyClass();
      return done();
    }
  };

  module.exports.basics.properties["get value"] = function(test) {
    test.expect(1);
    test.equal(this.instance.foo(), 'bar', "calling foo without arguments return the value of foo");
    return test.done();
  };

  module.exports.basics.properties["set value"] = function(test) {
    test.expect(1);
    this.instance.foo('new value');
    test.equal(this.instance.foo(), 'new value');
    return test.done();
  };

  module.exports.basics.properties["helper property"] = function(test) {
    test.expect(1);
    this.instance.foo('new value');
    test.equal(this.instance.foo(), this.instance._foo);
    return test.done();
  };

  module.exports.basics.properties["inmutable object"] = function(test) {
    var oldValue;
    test.expect(1);
    this.instance.set = function() {};
    oldValue = this.instance.foo();
    this.instance.foo('useless set operation');
    test.equal(this.instance.foo(), oldValue);
    return test.done();
  };

}).call(this);
