// We only need this custom loader because we want to exclude the additional `./scripts` dir
// https://github.com/benbria/coffee-coverage/blob/master/docs/HOWTO-istanbul.md#writing-a-custom-loader

var path = require('path');
var coffeeCoverage = require('coffee-coverage');
var projectRoot = path.resolve(__dirname, "../..");
var coverageVar = coffeeCoverage.findIstanbulVariable();
// Only write a coverage report if we're not running inside of Istanbul.
var writeOnExit = (coverageVar == null) ? (projectRoot + '/coverage/coverage-coffee.json') : null;

coffeeCoverage.register({
    instrumentor: 'istanbul',
    basePath: projectRoot,
    exclude: ['/test', '/node_modules', '/.git', '/scripts'],
    coverageVar: coverageVar,
    writeOnExit: writeOnExit,
    initAll: true
});
