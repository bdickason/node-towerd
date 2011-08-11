(function() {
  /* Simple Mongoose DB object */  var cfg, mongoose;
  mongoose = require('mongoose');
  cfg = require('../config/config.js');
  exports.db = mongoose.connect(cfg.DB, function(err) {
    if (err) {
      return logger.log('error', err);
    }
  });
  mongoose.connection.on('open', function() {
    return logger.info('Mongo is connected!');
  });
}).call(this);
