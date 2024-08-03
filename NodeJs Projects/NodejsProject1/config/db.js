
const mongoose = require("mongoose"); //Mongoose translates data between the database and JavaScript objects

const connection = mongoose.createConnection("mongodb://127.0.0.1:27017/newToDo").on('open', () => { console.log("mongodb connected"); }).on('error', () => { console.log("mongodb connected"); });
module.exports = connection;