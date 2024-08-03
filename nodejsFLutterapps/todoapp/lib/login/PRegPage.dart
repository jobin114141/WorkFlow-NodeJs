import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/login/config.dart';

class PRegPage extends StatefulWidget {
  const PRegPage({super.key});

  @override
  State<PRegPage> createState() => _PRegPageState();
}

class _PRegPageState extends State<PRegPage> {
  File? selectedImage;
  TextEditingController regUserName = TextEditingController();
  TextEditingController regEmilid = TextEditingController();
  TextEditingController regPhonenumber = TextEditingController();
  TextEditingController regPassword = TextEditingController();
  TextEditingController regLocattion = TextEditingController();
  bool loading = false;
  bool is_not_validated = false;
  String? ImageUrl;
  
void registeruser() async {
  try {
    if (regEmilid.text.isNotEmpty && regPassword.text.isNotEmpty) {
      var regBody = {
        'email': regEmilid.text,
        'password': regPassword.text,
      };

      var response = await http.post(
        Uri.parse(registration),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful response
        print('User registered successfully');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      } else {
        // Failed response
        print('Failed to register user');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } else {
      setState(() {
        is_not_validated = true;
      });
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                InkWell(
                  onTap: () {
                  
                  },
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: selectedImage != null
                        ? CircleAvatar(
                            maxRadius: 40,
                            backgroundImage: FileImage(
                                selectedImage!), //displaying image to reg after uploadingt
                          )
                        : CircleAvatar(
                            maxRadius: 40,
                            backgroundColor:
                                const Color.fromARGB(255, 207, 206, 206),
                            child: Icon(
                              Icons.person_add_alt,
                              size: 50,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextField(
                  controller: regUserName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "FULL NAME"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextField(
                  controller: regEmilid,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Email"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextField(
                  controller: regPhonenumber,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Phone number"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextField(
                  controller: regPassword,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Password"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextField(
                  controller: regLocattion,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Location"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFF008771)),
                  child: InkWell(
                    onTap: () {
                     registeruser();
                    },
                    child: Center(
                        child: loading != false
                    ? CircularProgressIndicator():Text(
                      "Register",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
