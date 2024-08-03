const UserModel = require('../model/user.model') //usermodel ena db model [ email & password attributes,db name-usermodel ]
const jwt =require("jsonwebtoken")
class UserService {
   static  async registerUser(email,password){ //registeruser function created with 2 parameters
        try{
            const createUser =  new UserModel({ email,password}); // saving to db 
            return await createUser.save(); // saved
        }catch(err){
            throw err;
        }
    }

    static async chechkuser(email){
        try{
            return await UserModel.findOne({email}); //if  this examil adress exist it returns all data of the user
                                                     // findone is used to find a single datas from mongodb
        }catch(error){
            throw error;
        }
    }
    static async generateToken(tokenData,secretkey,jwt_expire){
        return jwt.sign(tokenData,secretkey,{expiresIn:jwt_expire})
    }
}
module.exports=UserService;

