import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddFeedback extends StatefulWidget {
  String userID;
  AddFeedback(this.userID);
  @override
  State<StatefulWidget> createState() {
    return _AddFeedback();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _AddFeedback extends State<AddFeedback> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  String title;
  String content;
  String submitDate;
  final _formKey = GlobalKey<FormState>();
  bool loadSpinner = false;

  void uploadFeedback() async{
    setState(() {
     loadSpinner = true; 
    });
    DateTime now = new DateTime.now();
    var converter = new DateFormat('yyyy-MM-dd');
    submitDate = converter.format(now);
    final response = await http.post("http://xiaosha007.hostingerapp.com/addFeedback.php",body: {
      "title":title,
      "content":content,
      "submitDate":submitDate,
      "userID":widget.userID
    });
    if(response.statusCode==200){
      loadSpinner = false;
      Navigator.pop(context,response.statusCode);
    }
  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return ModalProgressHUD(child: 
      Scaffold(
        appBar: AppBar(
          title: Text("Submit Feedback"),
          actions: <Widget>[
            IconButton(
              onPressed: (){
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  _formKey.currentState.save();
                  uploadFeedback();
                }
              },
              icon: Icon(Icons.check),
            )
          ],
        ),
        body:SingleChildScrollView(child: 
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[ new Container(
                margin: EdgeInsets.only(right: 20.0, left: 20.0,bottom: 30),
                padding: EdgeInsets.all(10),
                child: new TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 100,
                  inputFormatters: [new LengthLimitingTextInputFormatter(20)],
                  decoration: InputDecoration(
                      labelText: 'Title',
                    counterText: ""
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value)=>title = value,
                ),
              ),
                new Container(
                  //padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 20.0, left: 20.0,bottom: 30),
                  child: new TextFormField(
                    maxLines: 20,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        //contentPadding: new EdgeInsets.symmetric(vertical: 20.0)
                      ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (value)=>content=value,
                  ),
                ),
              ],
            ),
          )
        )
      ),inAsyncCall: loadSpinner,
    );
  }
}