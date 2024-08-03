const router= require("express").Router();

const ToDoController= require("../controller/todo.controller");

router.post('/storeTodo',ToDoController.createToDo);     // this is the api addtress 

router.post('/getusertodolist',ToDoController.getusertodolist);

router.post('/deletetodolist',ToDoController.deletetodolist);

router.post('/edittodolist',ToDoController.edittodolist);

module.exports=router;