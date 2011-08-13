(function() {
  var coffee, isVerbose, jasmine, key, showColors, sys, _i, _len;
  jasmine = require('jasmine-node');
  sys = require('sys');
  for (_i = 0, _len = jasmine.length; _i < _len; _i++) {
    key = jasmine[_i];
    global[key] = jasmine[key];
  }
  isVerbose = true;
  showColors = true;
  coffee = true;
  process.argv.forEach(function(arg) {
    switch (arg) {
      case '--color':
        return showColors = true;
      case '--noColor':
        return showColors = false;
      case '--verbose':
        return isVerbose = true;
      case '--coffee':
        return coffee = true;
    }
  });
  jasmine.executeSpecsInFolder(__dirname + '/spec', (function(runner, log) {
    if (runner.results().failedCount === 0) {
      return process.exit(0);
    } else {
      return process.exit(1);
    }
  }), isVerbose, showColors);
}).call(this);
