import 'package:alumni_management_system/home.dart';
import './search.dart';
import 'package:alumni_management_system/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  bool loginStatus = false;
  bool loadingSpinner = false;
  bool isAdmin = false;

  _Login() {
    //getLoginData();
  }

  final studentID = TextEditingController();
  final password = TextEditingController();
  List<String> studentIdList =
      List<String>(); //store studentID retrived from database
  List<String> passwordList =
      List<String>(); //store password retrived from database

  Future<void> getLoginStatus() async {
    //to upload data to database
    print("Uploading Data....");
    setState(() {
      loadingSpinner = true;
    });
    final response = await http.post(
        'http://xiaosha007.hostingerapp.com/alumniLogin.php',
        body: {"studentID": studentID.text, "password": password.text});
    if (response.statusCode == 200) {
      final resultGet = json.decode(response.body);
      print(resultGet);
      if (resultGet == 1) {
        loginStatus = true;
        print("LOGIN status: " + loginStatus.toString());
      } else if(resultGet==2){
        loginStatus = true;
        isAdmin = true;
      }
      else{
        loginStatus = false;
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    void loginMessage(String status) {
      showDialog(
          //pop out message box
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Login " + status),
              content: status=="Successful"?Text("Welcome Back to Alumni Center!"):Text("Invalid student ID or password"),
              actions: <Widget>[
                FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      String userType = "Normal";
                      if (status == "Successful") {
                        if(isAdmin){userType = "Admin";}
                        else{userType = "Normal";}
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomePage(studentID.text,userType)));
                        
                      } else {
                        Navigator.of(context).pop();
                      }
                    })
              ],
            );
          });
    }

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Alumni Center"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login()));
              },
            )
          ],
        ),
        body: ModalProgressHUD(
            child: ListView(
          children: <Widget>[
            /*Container(child: 
              Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0
                ),
                ),
              margin: EdgeInsets.all(10.0)
            ),*/
            Image.asset(
              'image/logo.png',
              width: screenWidth * 0.6,
              height: screenWidth * 0.6,
            ),
            Column(
              children: <Widget>[
                //Text("Username: ",textAlign: TextAlign.center),
                Container(
                    width: screenWidth * 0.3,
                    child: TextField(
                        keyboardType: TextInputType.number,
                        //maxLength: 10,
                        controller: studentID,
                        //textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            labelText: "Student ID",
                            hintStyle: TextStyle(fontSize: 10.0)))),

                Container(
                  width: screenWidth * 0.3,
                  child: TextField(
                      //maxLength: 10,
                      obscureText: true,
                      controller: password,
                      decoration: InputDecoration(
                          labelText: "Password",
                          hintStyle: TextStyle(fontSize: 10.0))),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.black,
                onPressed: () {
                  getLoginStatus().then((value) {
                    /*****************Please REMOVE this LINE after server is ok!***********************/
                    //loginStatus = true;
                    /*****************Please REMOVE this LINE after server is ok!***********************/
                    if (loginStatus) {
                      loginMessage("Successful");
                    } else {
                      loginMessage("Failed");
                    }
                    setState(() {
                     loadingSpinner = false; 
                    });
                  });
                },
                child: Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Register(),
                      )
                    );
                },
                child: Text("Don't have an account? Register Now.",style: TextStyle(fontWeight: FontWeight.bold),))
          ],
        ),inAsyncCall: loadingSpinner,
      )
    );
  }
}
