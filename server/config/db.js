const mongoose = require('mongoose');

// Replace the following string with your MongoDB connection string
const mongoURI = 'mongodb://localhost:27017/LNS';

const connection = mongoose.createConnection(mongoURI)
    .on('open', () => {
        console.log("MongoDB Connected");
    })
    .on('error', (err) => {
        console.log("MongoDB connection error:", err);
    });

module.exports = connection;
