const ToDoModel = require('../model/todo.model') //usermodel ena db model [ email & password attributes,db name-usermodel ]

class ToDoService {
   static  async createTodo(userId,title,desc){ //registeruser function created with 2 parameters
        try{
            const createTodo =  new ToDoModel({ userId,title,desc}); // saving to db,as an object
            return await createTodo.save(); // saved
        }catch(err){
            throw err;
        }
    }

    static  async getusertodolist(userId){ 
        try{
            const todolist = ToDoModel.find({userId});   // find is used to find datas more than one from mongodb.
            return  todolist
        }catch(err){
            throw err;
        }
    }

    static  async deletetodolist(Id){ 
        try{
            const todolist = ToDoModel.findOneAndDelete({_id:Id});   // find is used to find datas more than one from mongodb.
            return  todolist
        }catch(err){
            throw err;
        }
    }

    static  async edittodolist(Id,title,desc){ 
        try{
            const todolist = ToDoModel.findOneAndUpdate({_id:Id}, {$set: {"title": title,"desc": desc}}
            )   // find is used to find datas more than one from mongodb.
            return  todolist
        }catch(err){
            throw err;
        }
    }

    
}




module.exports=ToDoService;

