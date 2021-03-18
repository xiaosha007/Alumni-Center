import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class SpecificFeedbackPage extends StatefulWidget{
  String feedbackID;
  SpecificFeedbackPage(this.feedbackID);
  @override
  State<StatefulWidget> createState() {
    
    return _SpecificFeedbackPage();
  }
}

class _SpecificFeedbackPage extends State<SpecificFeedbackPage>{

  String submitDate;
  String title;
  String content;
  String userID;
  List feedbackData = List();
  bool loadSpinner;

  void getFeedback()async{
    loadSpinner = true;
    final response = await http.get("http://xiaosha007.hostingerapp.com/getFeedback.php?feedbackID="+widget.feedbackID);
    if(response.statusCode==200){
      feedbackData = json.decode(response.body);
      submitDate = feedbackData[0]["SubmitDate"];
      title = feedbackData[0]["Title"];
      content = feedbackData[0]["Content"];
      userID = feedbackData[0]["UserID"];
      print(feedbackData);
    }
    setState(() {
      loadSpinner = false;
    });
  }
  
  @override
  void initState() {
    super.initState();
    getFeedback();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loadSpinner,
        child: userID!=null?ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: Text(title,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),
            Container(
              child: Text("Published on "+submitDate,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              margin: EdgeInsets.all(10),
            ),
            Container(
              //height: MediaQuery.of(context).size.height*0.3,
              //width: MediaQuery.of(context).size.width*0.7,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(25))
              ),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(20),
              child: Text(content,style: TextStyle(fontSize: 20,fontFamily: 'Acme',)),
            ),
          ],
        ):Container(color: Colors.white,),
      ),
    );
  }
}