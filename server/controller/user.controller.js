const UserService = require('../services/user.services')

exports.register = async(req, res, next) => {
    try {
        const {username, password, type} = req.body

        const successRes = await UserService.registerUser(username, password, type)

        if(!successRes) {
            throw new Error("Can't register")
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

exports.login = async(req, res, next) => {
    try {
        const {username, password, type} = req.body

        const user = await UserService.checkuser(username);

        if(!user) {
            throw new Error("User don't exist")
        }

        const isMatch = await user.comparePassword(password)

        if(isMatch === false) {
            throw new Error("Password InValid")
        }

        let tokenData = {_id:user._id,username:user.username,type:user.type}

        const token = await UserService.generateToken(tokenData, "secretKey", "1d")

        res.status(200).json({status:true, token:token})
    } catch(error) {
        res.json({
            status:false
        })
    }   
}

exports.forgetpassword = async(req, res, next) => {
    try {
        const {username, password, type} = req.body

        const user = await UserService.checkuser(username);

        if(!user) {
            throw new Error("User don't exist")
        }

        const successRes = await UserService.forgetpassword(username, password)

        if(!successRes) {
            throw new Error("Can't reset password")
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