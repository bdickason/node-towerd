(function() {
  /* Simple Mongoose DB object */  var cfg, mongoose, truncate;
  mongoose = require('mongoose');
  cfg = require('../config/config.js');
  exports.db = mongoose.connect(cfg.DB, function(err) {
    if (err) {
      return logger.log('error', err);
    }
  });
  mongoose.connection.on('open', function() {
    logger.info('Mongo is connected!');
    /* Wipe the DB on restart */
    return truncate();
  });
  truncate = function() {
    var m, model, _, _ref, _results;
    _ref = db.models;
    _results = [];
    for (_ in _ref) {
      model = _ref[_];
      m = db.model(Object.keys(model)[0]);
      _results.push(m.find({}, function(err, docs) {
        var doc, _i, _len, _results2;
        console.log('removing doc: ' + docs);
        _results2 = [];
        for (_i = 0, _len = docs.length; _i < _len; _i++) {
          doc = docs[_i];
          _results2.push(doc.remove());
        }
        return _results2;
      }));
    }
    return _results;
  };
}).call(this);
