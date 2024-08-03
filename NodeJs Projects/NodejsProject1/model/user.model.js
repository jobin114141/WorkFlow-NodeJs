const mongoose = require('mongoose'); //Mongoose translates data between the database and JavaScript objects
const db = require('../config/db');
const bcrypt = require('bcrypt');
const { Schema } = mongoose;

const userSchema = new Schema({
    email: {
        type: String,
        lowercase: true,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true, 
    },
    
});

userSchema.pre('save',async function(){  //The pre hook -validation sanitization, logging, or updating  before  saving a document.
    try{                               
        var user = this;
        const salt = await(bcrypt.genSalt(10));
        const hashpass= await bcrypt.hash(user.password,salt);
        user.password = hashpass;
    }catch(err){
        throw err
    }
})

userSchema.methods.comparePassword= async function(userPassword){
    try{
        const isMatch = await bcrypt.compare(userPassword,this.password); //cheching userpasswrod from ui existing in mongodb
        return isMatch;
    }catch(error){
        throw error;
    }
}

const userModel = db.model('User', userSchema);

module.exports = userModel; //email & password attributes,db name-usermodel
