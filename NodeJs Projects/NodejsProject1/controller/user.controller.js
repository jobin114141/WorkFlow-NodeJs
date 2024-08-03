const UserService = require("../services/user.services");

exports.register =async(req,res,next)=>{ //function req-from front end, res-to front end
    try{
        const{email,password}=req.body; //, the function extracts the email and password fields from the request body.

        const successRes= await UserService.registerUser(email,password); // passing the extracted email and password as arguments to registerUser function from the UserService

        res.json({status:true,success:"user registerd sucessfully"}); // displaying in postman 
    }catch(error){
        throw error
    }
}

exports.login =async(req,res,next)=>{ //function req-from front end, res-to front end
    try{
        const{email,password}=req.body; //, the function extracts the email and password fields from the request body.

        const user = await UserService.chechkuser(email);//checking email-id is exisng in db,fs existinng all details of the user is saved.
        if(!user){
            throw new Error('user donot exist');
        }

        const isMatch = await user.comparePassword(password); //password checking from db and from ui
        if(isMatch === false){
            throw new Error("password invalid");
        }

        let tokenData ={_id:user._id,email:user.email};

        const token = await UserService.generateToken(tokenData,"secretkey",'1hr')

        res.status(200).json({status:true,token:token})
    }catch(error){
        throw error
    }
}