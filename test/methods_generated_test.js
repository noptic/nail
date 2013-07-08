(function() {
  var nail;

  nail = require('../lib/nail.js');

  module.exports.basics = {};

  module.exports.basics.methods = {
    "setUp": function(done) {
      this.classes = {};
      nail.to(this.classes, 'nail.example', {
        MyClass: {
          methods: {
            hello: function() {
              return 'hello world';
            }
          }
        }
      });
      this.instance = new this.classes.MyClass();
      return done();
    },
    "calling a method": function(test) {
      test.expect(1);
      test.equal(this.instance.hello(), 'hello world');
      return test.done();
    }
  };

}).call(this);
