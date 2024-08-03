const mongoose = require('mongoose');
const db = require('../config/db');
const UserModel= require("../model/user.model")
const { Schema } = mongoose;

const TodoSchema = new Schema({
    userId: {
        type:Schema.Types.ObjectId,
        ref:UserModel.modelName
    },
    title: {
        type: String,
        required: true,
    },
    desc: {
        type: String,
        required: true,
    }
    
});

const ToDomodel = db.model('todo', TodoSchema);

module.exports = ToDomodel; //email & password attributes,db name-usermodel
