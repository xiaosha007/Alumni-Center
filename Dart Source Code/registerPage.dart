import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Register();
  }
}

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

class _Register extends State<Register> {
  final registerKey = GlobalKey<FormState>();
  String userName;
  String email;
  String country = "Malaysia";
  String studentID;
  String password;
  String userType = "Pending";
  String birthday;
  final FocusNode birthdayNode = FocusNode();
  bool loadSpinner = false;

  @override
  void dispose() {
    birthdayNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    birthdayNode.addListener(() {
      if (birthdayNode.hasFocus) {
        print("Birthday Node...");
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(1996,1,1),
            maxTime: DateTime(2005, 12, 31), onChanged: (date) {
              print('change $date');
            }, 
            onConfirm: (date) {
              print('confirm $date');
              setState(() {
                var converter = new DateFormat('yyyy-MM-dd');
                String converted = converter.format(date);
                birthday = converted;
                birthdayController.text = birthday;
              });
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      }
    });
  }

  bool regStatus;
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  Future<void> addData() async {
    final response = await http
        .post('http://xiaosha007.hostingerapp.com/registerAlumni.php', body: {
      "studentID": studentID,
      "userName": userName,
      "password": password,
      "email": email,
      "country": country,
      "userType": userType,
      "birthday": birthday
    });
    final resultGet = json.decode(response.body);
    print(resultGet);
    if (resultGet == 1) {
      regStatus = true;
    } else {
      regStatus = false;
    }
  }

  @override
  Widget build(BuildContext context) {
   // double screenWidth = MediaQuery.of(context).size.width;
    void registerMessage(String registerStatus) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Register"),
              content: Text(registerStatus),
              actions: <Widget>[
                FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      if (registerStatus == "Register Successfully!") {
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Login()));*/
                      } else {
                        Navigator.of(context).pop();
                      }
                    })
              ],
            );
          });
    }

    return ModalProgressHUD(
      child:Scaffold(
        appBar: AppBar(
          title: Text("Alumni Center"),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Form(
                    key: registerKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: "UserName",),
                          validator: (input) {
                            if (input.length < 6) {
                              return 'Username must contain at least 6 alphabets.';
                            } else
                              return null;
                          },
                          onSaved: (input) => userName = input,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Password"),
                          obscureText: true,
                          controller: passwordController,
                          validator: (input) {
                            if (input.length < 6) {
                              return 'Password must contain at least 6 characters.';
                            } else
                              return null;
                          },
                          onSaved: (input) => password = input,
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: "Re-enter password"),
                          obscureText: true,
                          validator: (input) {
                            if (input != passwordController.text) {
                              return 'Password entered is different.';
                            } else
                              return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(labelText: "Email"),
                          validator: (input) {
                            if (!input.contains('@') || !input.contains('.')) {
                              return 'Invalid email format';
                            } else
                              return null;
                          },
                          onSaved: (input) => email = input,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: "Student ID"),
                          validator: (input) {
                            if (input.length == 10 && isNumeric(input)) {
                              return null;
                            } else
                              return 'Invalid studentID';
                          },
                          onSaved: (input) => studentID = input,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Nationality"),
                          validator: (input) {
                            if (input.length>0) {
                              return null;
                            } else
                              return 'Invalid country';
                          },
                          onSaved: (input) => country = input,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Birthdate"),
                          focusNode: birthdayNode,
                          controller: birthdayController,
                          validator: (input) {
                            if (input.length>0) {
                              return null;
                            } else
                              return 'Invalid Birthdate';
                          },
                        )
                      ],
                    ))),
            RaisedButton(
              color: Colors.black,
              onPressed: () {
                print(studentID);
                if (registerKey.currentState.validate()) {
                  setState(() {
                    loadSpinner = true;
                  });
                  registerKey.currentState.save();
                  print(studentID);
                  addData().then((value) {
                    setState(() {
                     loadSpinner = false; 
                    });
                    if (regStatus) {
                      registerMessage("Register Successfully!");
                    } else {
                      registerMessage(
                          "The studentID or email entered has been used by another alumni.");
                    }
                  });
                }
              },
              child: Text(
                "Register",
                style: TextStyle(color: Colors.white,fontSize: 20),
              ),
            )
          ],
        ),
      ),inAsyncCall: loadSpinner,
    );
  }
}
