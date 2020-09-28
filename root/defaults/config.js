const CONFIG = {
  baseURI: '/',
  dbCleanInterval: 1000 * 60 * 60,
  dbPath: '/config/flood-db/',
  floodServerPort: 3000,
  maxHistoryStates: 30,
  pollInterval: 1000 * 5,
  secret: '<FLOOD_SECRET>',
  disableUsersAndAuth: true,
  configUser: {
    host: 'localhost',
    port: 5000,
    socket: true,
    socketPath: '/run/php/.rtorrent.sock'
  },
  ssl: false,
  sslKey: '/config/nginx/key.pem',
  sslCert: '/config/nginx/cert.pem',
};

module.exports = CONFIG;
