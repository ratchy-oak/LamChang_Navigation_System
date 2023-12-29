const userModel = require('../model/user.model')

class UserService {
    static async registerUser(username, password, type) {
        try {
            const createUser = new userModel({username, password, type})
            return await createUser.save()
        } catch(error) {
            throw error
        }
    }
}

module.exports = UserService