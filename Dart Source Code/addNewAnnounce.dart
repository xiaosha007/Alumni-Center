
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddNewAnnouncement extends StatefulWidget{
  String userID;
  AddNewAnnouncement(this.userID);
  @override
  State<StatefulWidget> createState() {
    return _AddNewAnnouncement();
  }
}

class _AddNewAnnouncement extends State<AddNewAnnouncement>{

  final _formKey = GlobalKey<FormState>();
  String title;
  String content;
  String publishDate;
  String userID;
  bool loadSpinner = false;

  void addAnnouncement() async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      print(content);
      setState(() {
       loadSpinner=true; 
      });
    }
    else return;
    DateTime now = new DateTime.now();
    var converter = new DateFormat('yyyy-MM-dd');
    publishDate = converter.format(now);
    userID = widget.userID;
    final response = await http.post("http://xiaosha007.hostingerapp.com/addAnnouncement.php",body:{
      "userID" : userID,
      "title" : title,
      "content" : content,
      "publishDate" : publishDate
    });
    if(response.statusCode == 200){
      print("Announcement added....");
    }
    else{
      print("Failed to upload announcement...");
    }
    setState(() {
      loadSpinner = false;
      Navigator.pop(context,response.statusCode);
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Announcement"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: (){
              addAnnouncement();
            },
          )
        ],
      ),
      body:ModalProgressHUD(child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child:TextFormField(
                      decoration: InputDecoration(labelText: "Title"),
                      validator: (value){
                        if(value.length==0){
                          return "At least write something...";
                        }
                        return null;
                      },
                      onSaved: (input)=>title=input,
                    ),
                  ),
                  TextFormField(
                    maxLines: 15,
                    decoration: InputDecoration(
                      labelText: "Content",
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: (value){
                      if(value.length==0){
                        return "At least write something...";
                      }
                      return null;
                    },
                    onSaved: (input)=>content=input,
                  ),
                ],
              ),
            ),
          )
        ],
      ),inAsyncCall: loadSpinner,
    ));
  }
}