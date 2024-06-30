const router = require('express').Router()
const EventController = require('../controller/event.controller')

router.post('/reportevent', EventController.report)
router.get('/events', EventController.fetchEvents)

module.exports = router