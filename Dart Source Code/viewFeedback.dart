import 'package:alumni_management_system/specificFeedbackPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ViewFeedback extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    
    return _ViewFeedback();
  }
}

class _ViewFeedback extends State<ViewFeedback>{
  bool loadSpinner = false;
  List feedbackList = List();


  void getFeedback()async{
    loadSpinner = true;
    final response = await http.get("http://xiaosha007.hostingerapp.com/getFeedback.php?feedbackID=all");
    if(response.statusCode==200){
      feedbackList = json.decode(response.body);
      print(feedbackList);
    }
    setState(() {
      loadSpinner = false;
    });
  }

  List feedbackBody(){
    return feedbackList.map((feedback)=>
      ListTile(
          title: Text(feedback["Title"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          subtitle: Text("Published on "+ feedback["SubmitDate"]),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context)=>SpecificFeedbackPage(feedback["FeedbackID"])
            ));
          },
        )
      /*InkWell(
        onTap:(){
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context)=>SpecificFeedbackPage(feedback["FeedbackID"])
          ));
        },
        child:Card(
          margin: EdgeInsets.all(10),
          color: Colors.blueAccent,
          child: Container(
            //height: MediaQuery.of(context).size.height*0.2,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(feedback["Title"]==null?"Default":feedback["Title"],style: TextStyle(fontSize: 25,color: Colors.white),textAlign: TextAlign.center,),
                Text("Submitted on "+feedback["SubmitDate"]==null?"Default":feedback["SubmitDate"],style: TextStyle(color:Colors.white),)
              ],
            ),
          ),  
        )
      )*/
    ).toList();
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
      body:ModalProgressHUD(
        inAsyncCall: loadSpinner,
        child:  ListView(
          children: feedbackList.length>0? feedbackBody():<Widget>[Container(color: Colors.white,)]
        ),
      ) 
    );
  }
}