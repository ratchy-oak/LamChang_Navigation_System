const UserService = require('../services/user.services')

exports.register = async(req, res, next) => {
    try {
        const {username, password, type} = req.body

        const successRes = await UserService.registerUser(username, password, type)

        res.json({
            status:true, 
            success:"User Registered Successfully"
        })
    } catch(error) {
        throw error
    }
}