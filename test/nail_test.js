(function() {
    var nail;

    nail = require('../lib/nail.js');

    exports['package'] = {
        setUp: function(done) {
            this.classes = {};
            nail.to(this.classes, 'myNamespace', {
                ParentClass: {
                    properties: {
                        name: 'anon',
                        age: 42
                    },
                    methods: {
                        hello: function() {
                            return "hello " + this.name;
                        }
                    }
                }
                /*e
                 nail.to @classes, 'myNamespace', ChildClass:
                 extend: @classes.ParentClass
                 properties:
                 name: 'someone'
                 methods:
                 hello:
                 0:  -> @$parent.hello()
                 n:  (suffix)-> "#{@hello()}, #{suffix}"
                 */

            });
            this.instance = new this.classes.Sample();
            this.childInstance = new this.classes.ParentClass();
            return done();
        },
        'proprty combined get/set': function(test) {
            test.expect(2);
            test.equal(this.instance.name(), 'anon');
            this.instance.name('tester');
            test.equal(this.instance.name(), 'tester');
            return test.done();
        }
    };

}).call(this);
