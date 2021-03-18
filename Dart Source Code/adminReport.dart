import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class AdminReport extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    
    return _AdminReport();
  }
}

class _AdminReport extends State<AdminReport>{

  List userData = List();
  List eventData = List();
  List jobData = List();
  bool loadSpinner = false;


  void getData()async {
    loadSpinner = true;
    final userResponse = await http.get("http://xiaosha007.hostingerapp.com/getUserDetails.php?studentID=all");
    if(userResponse.statusCode==200){
      userData = json.decode(userResponse.body);
    }
    final eventResponse = await http.get("http://xiaosha007.hostingerapp.com/getEventDetails.php?eventID=all&userID=&upcoming=false");
    if(eventResponse.statusCode==200){
      eventData = json.decode(eventResponse.body);
    }
    final jobResponse = await http.get("http://xiaosha007.hostingerapp.com/getJobDetails.php?jobID=all");
    if(jobResponse.statusCode==200){
      jobData = json.decode(jobResponse.body);
    }
    setState(() {
      loadSpinner = false;
    });
  }


  List tableRowGenerator(List inputData,String dataType){
    /*if(inputData.length<=0) return [TableRow(children:
          [Container(margin:EdgeInsets.all(10),child:Text("Nothing")),
          Container(margin:EdgeInsets.all(10),child:Text("Nothing")),
          Container(margin:EdgeInsets.all(10),child:Text("Nothing"))])
        ];*/
    String firstData;
    String secondData;
    String thirdData;
    if(dataType=="user"){
      firstData = "UserID";
      secondData = "UserName";
      thirdData = "Email";
      inputData.insert(0, {"UserID":"UserID","UserName":"UserName","Email":"Email"});
    }
    else if(dataType == "event"){
      firstData = "Title";
      secondData = "Venue";
      thirdData = "Date";
      inputData.insert(0, {"Title":"Title","Venue":"Venue","Date":"Date"});
    }
    else{
      firstData = "JobTitle";
      secondData = "CompanyName";
      thirdData = "DatePosted";
      inputData.insert(0, {"JobTitle":"JobTitle","CompanyName":"Company","DatePosted":"DatePosted"});
    }
    return inputData.map((data)=>
      TableRow(
        children: [
          Container(margin:EdgeInsets.all(10),child:Text(data[firstData]!=null?data[firstData]:"Loading...",style: TextStyle(fontFamily: 'Acme'),)),
          Container(margin:EdgeInsets.all(10),child:Text(data[secondData]!=null?data[secondData]:"Loading...",style: TextStyle(fontFamily: 'Acme'))),
          Container(margin:EdgeInsets.all(10),child:Text(data[thirdData]!=null?data[thirdData]:"Loading...",style: TextStyle(fontFamily: 'Acme'))),
        ] 
      )
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    
    return ModalProgressHUD(
      child:DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Report"),
            bottom: TabBar(
              dragStartBehavior: DragStartBehavior.start,
              /*onTap: (index){
                if(index==0){
                  dataType = "user";
                  getData(dataType);
                  print("First Page...");
                }
                else if(index==1){
                  dataType = "job";
                  getData(dataType);
                  print("second Page...");
                }
                else{
                  dataType = "event";
                  getData(dataType);
                  print("Third page...");
                }
              },*/
              tabs: <Widget>[
                Tab(
                  text: "User",
                  icon: Icon(Icons.people),
                  
                ),
                Tab(
                  icon: Icon(Icons.work),
                  text: "Job",
                ),
                Tab(
                  icon: Icon(Icons.event),
                  text: "Event",
                )
              ],
            ),
          ),
          body: 
          TabBarView(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                padding: EdgeInsets.all(10),
                child:Table(
                    border: TableBorder.all(),
                    children: tableRowGenerator(userData,"user"),
                  ),
                )
              ),
              SingleChildScrollView(  
                child:Container(
                  padding: EdgeInsets.all(10),
                  child:
                    Table(
                      border: TableBorder.all(),
                      children: tableRowGenerator(jobData,"job"),
                    ),
                  )
              ),
              SingleChildScrollView(
                child:Container(
                  padding: EdgeInsets.all(10),
                  child:
                    Table(
                      border: TableBorder.all(),
                      children: tableRowGenerator(eventData,"event"),
                    ),
                  ),
              )
            ],
          ),
        ),
      ),
      inAsyncCall: loadSpinner,
    );
  }
}