const mongoose = require('mongoose')

const connection = mongoose.createConnection('mongodb+srv://ratchy-oak:Rachakrit12@lnscluster.nsrrxfc.mongodb.net/LNS').on('open', () => {
    console.log("MongoDB Connected")
}).on('error', () => {
    console.log("MongoDB connection error")
})

module.exports = connection