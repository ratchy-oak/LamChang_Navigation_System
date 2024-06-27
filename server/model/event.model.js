const mongoose = require('mongoose')
const db = require('../config/db')

const {Schema} = mongoose

const eventSchema = new Schema({
    event:{
        type:String,
        required:true
    },
    sex:{
        type:String,
        required:true
    },
    age:{
        type:String,
        required:true
    },
    symptom:{
        type:String,
        required:true
    },
    name:{
        type:String,
        required:true
    },
    phone:{
        type:String,
        required:true
    },
    location:{
        type:Number,
        required:true
    }
})

eventSchema.pre('save', async function() {})

const EventModel = db.model('event', eventSchema);

module.exports = EventModel