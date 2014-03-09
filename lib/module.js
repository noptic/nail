var common, core;

common = require('nail-common');

core = require('nail-core');

module.exports = core.use(common.parent, common.fields, common.properties, common.methods, common.injector);
