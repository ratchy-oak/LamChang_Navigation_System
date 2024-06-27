const EventModel = require('../model/event.model')

class EventService {
    static async reportEvent(event, sex, age, symptom, name, phone, location) {
        try {
            const createEvent = new EventModel({event, sex, age, symptom, name, phone, location})
            return await createEvent.save()
        } catch(error) {
            throw error
        }
    }
}

module.exports = EventService