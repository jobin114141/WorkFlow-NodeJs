const ToDoService = require("../services/todo.services");

exports.createToDo =async(req,res,next)=>{ //function req-from front end, res-to front end
    
    try{
        const{userId,title,desc}=req.body; //, the function extracts the email and password fields from the user .

        let todo= await ToDoService.createTodo(userId,title,desc); // passing the extracted email and password as arguments to registerUser function from the UserService

        res.json({status:true,success:todo}); // displaying in postman 
    }catch(error){
        throw error
    }
}

exports.getusertodolist =async(req,res,next)=>{ 
    try{
        const{userId}=req.body; 

        let todo= await ToDoService.getusertodolist(userId); 
        res.json({status:true,success:todo}); 
    }catch(error){
        throw error
    }

}

exports.deletetodolist =async(req,res,next)=>{ 
    try{
        const{Id}=req.body; 

        let todo= await ToDoService.deletetodolist(Id); 
        res.json({status:true,success:todo}); 
    }catch(error){
        throw error
    }
}

exports.edittodolist =async(req,res,next)=>{ 
    
    try{
        const{Id,title,desc}=req.body;
        console.log(`${Id}`);
        console.log(`${title}`);
        console.log(`${desc}`); 
        let todo= await ToDoService.edittodolist(Id,title,desc); 
        res.json({status:true,success:todo,message:"ok"}); 
    }catch(error){
        throw error
    }
}
