
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/login/PRegPage.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/login/config.dart';
import 'package:todoapp/login/dashboard.dart';
class PLoginPage extends StatefulWidget {
  const PLoginPage({super.key});

  @override
  State<PLoginPage> createState() => _PLoginPageState();
}

class _PLoginPageState extends State<PLoginPage> {
  
  TextEditingController loginemail = TextEditingController();
  TextEditingController loginpassword = TextEditingController();
  bool is_loading = false;

  late SharedPreferences prefs; 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initsharedPref();
  }

  void initsharedPref()async{
    prefs = await SharedPreferences.getInstance();
  }

  void loginuser() async {
  try {
    if (loginemail.text.isNotEmpty && loginpassword.text.isNotEmpty) {
      var regBody = {                                      // saving values to var to send to the API
        'email': loginemail.text,
        'password': loginpassword.text,
      };

      var response = await http.post(                       // sending data to login API
        Uri.parse(login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody)
      );

    var jsonResponse = jsonDecode(response.body);           //Decoding the respones 

    if(jsonResponse['status']){                             //if status is TRUE then 

        var myToken = jsonResponse['token'];                //jws token like email and all  saved too the variable

        prefs.setString('token', myToken);                  // a saving to the shared prefrence
        
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard(token: myToken)));
    }else{
      print("something went wrong");
    }
     
    } else {
     
    }
  } catch (e) {
    // Handle any exceptions
    print('Error occurred: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://images.pexels.com/photos/2414036/pexels-photo-2414036.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                  fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                TextField(
                  controller: loginemail,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), hintText: "Email"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                TextField(
                  controller: loginpassword,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), hintText: "Password"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                InkWell(
                  onTap: () {
                    loginuser();
                   
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFF008771)),
                    child: Center(
                        child: is_loading == true
                            ? CircularProgressIndicator()
                            : Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              )),
                  ),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return PRegPage();
                      }));
                    },
                    child: Text("dont have an account?"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
