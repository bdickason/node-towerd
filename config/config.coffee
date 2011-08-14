### Config.coffee - Configuration of random stuffs ###

# Game Configuration
exports.GAMETIMER = process.env.GAMETIMER || 1000   # The amount of time between 'world' events

# Client - Tile Size, etc
exports.TILESIZE = process.env.TILESIZE || 10


# Individual unit configs are in /data/

exports.SESSION_SECRET = process.env.SESSION_SECRET || 'internets'
exports.SESSION_ID = process.env.SESSION_ID || 'express.sid'

# Redis
exports.REDIS_HOSTNAME = process.env.REDIS_HOSTNAME || 'localhost'
exports.REDIS_PORT = process.env.REDIS_PORT || 6379
exports.REDIS_CACHE_TIME = process.env.REDIS_CACHE_TIME || 10000    #Time to cache objects (in seconds)

# Mongo
exports.MONGO_HOST = process.env.MONGO_HOST || 'localhost'
exports.MONGO_DB = process.env.MONGO_DB || 'game'

# Loggly (optional)
exports.LOGGLY_SUBDOMAIN = process.env.LOGGLY_SUBDOMAIN || ''
exports.LOGGLY_INPUTTOKEN = process.env.LOGGLY_INPUTTOKEN || ''

## DON'T TOUCH
exports.DB = 'mongodb://' + @MONGO_HOST + '/' + @MONGO_DB