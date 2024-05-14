const { Pool } = require('pg');

require('dotenv').config()
console.log("db stuffd = ", process.env.POSTGRES_USER, process.env.POSTGRES_HOST, process.env.POSTGRES_DB, process.env.POSTGRES_PW, process.env.POSTGRES_PORT)
const pool = new Pool({
  user: process.env.POSTGRES_USER,
  host: process.env.POSTGRES_HOST,
  database: process.env.POSTGRES_DB,
  password: process.env.POSTGRES_PW,
  port: process.env.POSTGRES_PORT,
});

module.exports = pool;