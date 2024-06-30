const EventService = require('../services/event.services')

exports.report = async(req, res, next) => {
    try {
        const {event, sex, age, symptom, name, phone, location} = req.body

        const successRes = await EventService.reportEvent(event, sex, age, symptom, name, phone, location)

        if(!successRes) {
            throw new Error("Can't report")
        }

        res.json({
            status:true
        })
    } catch(error) {
        res.json({
            status:false
        })
    }
}

exports.fetchEvents = async(req, res, next) => {
    try {
        const events = await EventService.fetchEvents()
        res.json({
            status: true,
            data: events
        })
    } catch (error) {
        res.json({
            status: false,
            error: error.message
        })
    }
}