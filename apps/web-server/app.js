const express = require('express');
const mysql = require('mysql2');

// Initialize Express app
const app = express();
const port = process.env.PORT || 3000;

// Set up MySQL connection
const connection = mysql.createConnection({
  host: process.env.MYSQL_HOST || 'localhost',
  user: process.env.MYSQL_USER || 'root',
  password: process.env.MYSQL_PASSWORD || 'password',
  database: process.env.MYSQL_DATABASE || 'testdb'
});

// Start the connection and log success
connection.connect(err => {
  if (err) {
    console.log('Database connection failed:', err.message);
    return;
  }
  console.log('Connected to MySQL database');
});

// Define the root route
app.get('/', (req, res) => {
  // Return a default message
  res.status(200).send('WEBSERVER IS RUNNING!');
});

// Start the server listening on the specified port
app.listen(port, () => {
  console.log(`App running on port ${port}`);
});

