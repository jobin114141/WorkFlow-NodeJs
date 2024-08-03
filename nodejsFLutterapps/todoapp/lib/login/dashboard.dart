import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/login/PloginPage.dart';
import 'dart:convert';

import 'package:todoapp/login/config.dart';

class Dashboard extends StatefulWidget {
  final String token;
  const Dashboard({required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String userid;
  TextEditingController titlectrl = TextEditingController();
  TextEditingController Descriptionctrl = TextEditingController();
  List? items;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userid = jwtDecodedToken['_id'];
    gettodolist(userid);
  }

  void additm() async {
    try {
      if (titlectrl.text.isNotEmpty && Descriptionctrl.text.isNotEmpty) {
        var regBody = {
          'userId': userid,
          'title': titlectrl.text,
          'desc': Descriptionctrl.text,
        };

        var response = await http.post(Uri.parse(storeTodo),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regBody));

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']) {
          titlectrl.clear();
          Descriptionctrl.clear();

          Navigator.of(context).pop();
          gettodolist(userid);
        } else {
          print("something went wrong");
        }
      } else {}
    } catch (e) {
      print('Error occurred: $e');
    }
  }
  
void edittodolist(BuildContext context, TextEditingController Editctrltitle, TextEditingController Editctrldesc, String id) async {
  print("Title: ${Editctrltitle.text}");
  print("Description: ${Editctrldesc.text}");

  try {
    if (Editctrltitle.text.isNotEmpty && Editctrldesc.text.isNotEmpty) {
      var regBody = {
        'Id': id,
        'title': Editctrltitle.text,
        'desc': Editctrldesc.text,
      };
      print("Request Body: $regBody");

      var response = await http.post(
        Uri.parse(EditTodolista), // Ensure EditTodolista is a valid URL
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );
      print("Response Body: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        Editctrltitle.clear();
        Editctrldesc.clear();

        Navigator.of(context).pop();
        gettodolist(userid); // Ensure userid is defined and valid
      } else {
        print("Error: ${jsonResponse['message']}");
      }
    } else {
      print("Title or description is empty");
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

  void gettodolist(userid) async {
    try {
      var regBody = {
        'userId': userid,
      };

      var response = await http.post(Uri.parse(getTodolista),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));
      var jsonResponse = jsonDecode(response.body);

      items = jsonResponse['success'];
      setState(() {});
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void Deletetodolist(id) async {
    print(id.toString());
    try {
      var regBody = {
        'Id': id,
      };

      var response = await http.post(Uri.parse(deleteTodolista),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        gettodolist(userid);
      }

      setState(() {});
    } catch (e) {
      print('response.body error');
    }
  }

  void LogOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.38,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: InkWell(
                          onTap: () {
                            print("tapped");
                            LogOut();
                          },
                          child: Text("Log Out")),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.list),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 20),
                  child: Text(
                    "ToDo with NodeJS + \nMongodb",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: items == null
                      ? Container()
                      : Text(
                          "${items!.length} Tasks",
                          style: TextStyle(fontSize: 20),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Swipe Left For More",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: items == null
                ? null
                : ListView.builder(
                    itemCount: items!.length,
                    itemBuilder: (ctx, index) {
                      return Slidable(
                          key: const ValueKey(0),
                          endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {}),
                              children: [
                                SlidableAction(
                                    label: 'Edit',
                                    icon: Icons.edit,
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(231, 213, 18, 18),
                                    onPressed: (BuildContext context) {
                                      String? id =
                                          items![index]["_id"];
                                      String? titletemp =
                                          items![index]["title"];
                                      String? desctemp = items![index]["desc"];

                                      showEditableData(
                                          context, titletemp!, desctemp!,id!);
                                    }),
                                SlidableAction(
                                    label: 'Delete',
                                    icon: Icons.delete,
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(65, 0, 0, 0),
                                    onPressed: (BuildContext context) {
                                      Deletetodolist("${items![index]["_id"]}");
                                      print("${items![index]["_id"]}");
                                    })
                              ]),
                          child: Card(
                            borderOnForeground: false,
                            child: ListTile(
                              leading: Icon(Icons.task),
                              trailing: Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_back),
                                ],
                              )),
                              title: Text("${items![index]["title"]}"),
                              subtitle: Text("${items![index]["desc"]}"),
                            ),
                          ));
                    }),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDataAlert(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 29,
        ),
        backgroundColor: Color.fromARGB(255, 12, 72, 192),
        tooltip: 'Capture Picture',
        elevation: 5,
        splashColor: Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  void showDataAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 10.0),
          title: Text(
            "Add to To-Do",
            style: TextStyle(fontSize: 24.0),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: titlectrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Title',
                        labelText: 'Title',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: Descriptionctrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Description',
                        labelText: 'Description',
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        additm();
                      },
                      child: Text("Add"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

 void showEditableData(BuildContext context, String titletemp, String desctemp, String id) {
  TextEditingController Editctrltitle = TextEditingController(text: titletemp);
  TextEditingController Editctrldesc = TextEditingController(text: desctemp);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        contentPadding: EdgeInsets.only(top: 10.0),
        title: Text(
          "Edit To-Do",
          style: TextStyle(fontSize: 24.0),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: Editctrltitle,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Title',
                      labelText: 'Title',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: Editctrldesc,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Description',
                      labelText: 'Description',
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      edittodolist(context, Editctrltitle, Editctrldesc, id);
                    },
                    child: Text("Edit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
}
