const UserModel = require('../model/user.model')
const jwt = require('jsonwebtoken')

class UserService {
    static async registerUser(username, password, type) {
        try {
            const createUser = new UserModel({username, password, type})
            return await createUser.save()
        } catch(error) {
            throw error
        }
    }

    static async checkuser(username) {
        try {
            return await UserModel.findOne({username})
        } catch (error) {
            throw error
        }
    }

    static async generateToken(tokenData, secretKey, jwt_expire) {
        return jwt.sign(tokenData, secretKey, {expiresIn:jwt_expire})
    }
}

module.exports = UserService