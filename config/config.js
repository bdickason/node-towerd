(function() {
  /* Config.coffee - Configuration of random stuffs */  exports.SESSION_SECRET = process.env.SESSION_SECRET || 'internets';
  exports.SESSION_ID = process.env.SESSION_ID || 'express.sid';
  exports.REDIS_HOSTNAME = process.env.REDIS_HOSTNAME || 'localhost';
  exports.REDIS_PORT = process.env.REDIS_PORT || '6379';
  exports.REDIS_CACHE_TIME = process.env.REDIS_CACHE_TIME || '10000';
  exports.MONGO_HOST = process.env.MONGO_HOST || 'localhost';
  exports.MONGO_DB = process.env.MONGO_DB || 'game';
  exports.LOGGLY_SUBDOMAIN = process.env.LOGGLY_SUBDOMAIN || '';
  exports.LOGGLY_INPUTTOKEN = process.env.LOGGLY_INPUTTOKEN || '';
  exports.DB = 'mongodb://' + this.MONGO_HOST + '/' + this.MONGO_DB;
}).call(this);
