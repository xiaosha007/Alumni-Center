import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';
import 'package:numberpicker/numberpicker.dart';


class EditUserProfile extends StatefulWidget{
  String userID;
  EditUserProfile(this.userID);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditUserProfile();
  }
}

class _EditUserProfile extends State<EditUserProfile>{
  final _formKey = GlobalKey<FormState>();
  final FocusNode yearFocusNode = FocusNode();
  int _currentYear = 2019;
  TextEditingController _yearController = new TextEditingController();
  bool loadSpinner = false;

  @override
  void initState() {
    super.initState();
    yearFocusNode.addListener(
      (){
        if(yearFocusNode.hasFocus){
          showDialog(
            context: context,
            builder: (BuildContext context){
              return new NumberPickerDialog.integer(
                initialIntegerValue: _currentYear,
                minValue: 1996,
                maxValue: 2019, 
              );
            }
          ).then((yearPicked){
            setState(() {
              if(yearPicked!=null){
                 _currentYear = yearPicked; 
                 _yearController.text = yearPicked.toString();
              }
            });
          });
        }
      }
    );
  }

  void uploadData() async {
    setState(() {
      loadSpinner = true;
    });
    String uploadLink = "http://xiaosha007.hostingerapp.com/editAlumniDetails.php";
    final response = await http.post(uploadLink,body: {
      "description" : description,
      "mobileNum" : mobileNum,
      "address" : address,
      "course" : course,
      "yearOfGraduation" : yearOfGraduation,
      "userID": widget.userID
    });
    final resultGet = json.decode(response.body);
    print(resultGet);
    loadSpinner = false;
    if(resultGet == 1){
      Navigator.pop(context,response.statusCode);
      /*showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Edit successfully!"),
            content: Text("Your information has been updated!"),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
          );*/
      print("Edit successfully!");
    }
  }

  String description;
  String mobileNum;
  String address;
  String course;
  String yearOfGraduation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: (){
              if(_formKey.currentState.validate()){
                _formKey.currentState.save();
                uploadData();
                print("Inputs are accepted...");
              }
            },
          )
        ],
      ),
        body: ModalProgressHUD( child:
          ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child:
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: "User Description"),
                          validator: (value){
                            if(value.length==0){
                              return "At least write something...";
                            }
                            return null;
                          },
                          onSaved: (input)=>description=input,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Mobile Number"),
                          validator: (value){
                            if((value.length < 10 || value.length > 11)){
                              return "At least write something...";
                            }
                            return null;
                          },
                          onSaved: (input)=>mobileNum=input
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Address"),
                          validator: (value){
                            if(value.length == 0){
                              return "At least write something...";
                            }
                            return null;
                          },
                          onSaved: (input)=>address=input
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Course Taken During University Time"),
                          validator: (value){
                            if(value.length == 0){
                              return "At least write something...";
                            }
                            return null;
                          },
                          onSaved: (input)=>course=input
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Year of Graduation"),
                          focusNode: yearFocusNode,
                          controller: _yearController,
                          validator: (value){
                            if(value.length == 0){
                              return "At least write something...";
                            }
                            return null;
                          },
                          onSaved: (input)=>yearOfGraduation=input
                        ),
                      ],
                    ),
                  ),
              ),
            ],
          ),
          inAsyncCall: loadSpinner,
        ),
    );
  }
}