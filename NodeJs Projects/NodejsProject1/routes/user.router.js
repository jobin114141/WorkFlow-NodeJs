const router= require("express").Router();

const UserController= require("../controller/user.controller");

router.post('/registration',UserController.register); //ith anu postman il idenda address
router.post('/login',UserController.login);
module.exports=router;