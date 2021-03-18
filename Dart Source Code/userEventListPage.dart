import 'package:alumni_management_system/addNewEvent.dart';
import 'package:alumni_management_system/specificEventPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UserEventListPage extends StatefulWidget{
  String userID;
  String userType;
  UserEventListPage(this.userID,this.userType);
  @override
  State<StatefulWidget> createState() {
    
    return _UserEventListPage();
  }
}

class _UserEventListPage extends State<UserEventListPage>{

  List eventDataList =  List();
  List approvedEventList = List();
  List pendingEventList = List();
  List specificUserEventList = List();
  bool loadingSpinner = false;

  @override
  void initState() {
    print("Init event list...");
    super.initState();
    getEventData();
  }

  void getEventData() async{  //retrive event from hosting server
    eventDataList.clear();
    approvedEventList.clear();
    pendingEventList.clear();
    specificUserEventList.clear();
    loadingSpinner = true;
    final response = await http.get("http://xiaosha007.hostingerapp.com/getEventDetails.php?eventID=all&userID=&upcoming=false");
    final eventList = json.decode(response.body);
    print(eventList);
    for(int i=0;i<eventList.length;i++){
      if(widget.userType=="Admin"){
        if(eventList[i]["Status"]=="A"){
          approvedEventList.add(eventList[i]);
        }
        else if(eventList[i]["Status"]=="P"){
          pendingEventList.add(eventList[i]);
        }
      } 
      if(eventList[i]["Status"]=="A"){
        eventDataList.add(eventList[i]);
      }
      if(eventList[i]["UserID"] == widget.userID){
        specificUserEventList.add(eventList[i]);
      }
    }
    setState(() {
      loadingSpinner = false;
    });
  }


  List eventCard(List eventList){  //convert every elements inside list into a card list
    return eventList.map((event)=>
    Builder(builder:(BuildContext context)=>
      InkWell(
        onTap: (){
          Navigator.push(context,MaterialPageRoute(
            builder: (BuildContext context)=>SpecificEventPage(event["EventID"],widget.userType)
          )).then(
            (status){
              if(status==200){
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Event status changed successfully"),));
              }
            }
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height*0.4,
          margin: EdgeInsets.all(10.0),
          child:Card(
            child: Column(
              children: <Widget>[
                Container(
                  child:Image.network("http://xiaosha007.hostingerapp.com/EventPoster/"+event["EventID"],fit:BoxFit.fitWidth),
                  height: MediaQuery.of(context).size.height*0.35,
                  width: MediaQuery.of(context).size.width,
                ),
                Text(event["Title"])
              ],
            ),
          )
        ),
      )
    )
   ).toList();
  }


  DefaultTabController normalBody(){ //display when normal user login
    return DefaultTabController(
      length: 2,
      child:Scaffold(
        appBar: AppBar(
          title: Text("Event List"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text:"All Events"),
              Tab(text:"My Event(s)")
            ],
          ),
        ),
        body: TabBarView(
          children:[
            ModalProgressHUD(
              child:  ListView(
                children: eventDataList.length>0 ? eventCard(eventDataList) : <Widget>[Container(color: Colors.white,)]
              ),
              inAsyncCall: loadingSpinner,
            ),
            ModalProgressHUD(
              child:  ListView(
                children: eventDataList.length>0 ? eventCard(specificUserEventList) : <Widget>[Container(color: Colors.white,)]
              ),
              inAsyncCall: loadingSpinner,
            ),
          ]
        ),
        floatingActionButton: Builder( builder:(BuildContext context)=>FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context)=>AddNewEvent(widget.userID,widget.userType)
              )).then((status){
                if(status == 200){
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Event application submitted."),duration: Duration(seconds: 5),));
                }
              });
            },
            child: Icon(Icons.add),
          ),
          )
        )
      );
  }

  DefaultTabController adminBody(){ //display when admin login
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Events"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: "Approved",),
              Tab(text: "Pending",)
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ModalProgressHUD(
              child:  ListView(
                children: approvedEventList.length>0 ? eventCard(approvedEventList) : <Widget>[Container(color: Colors.white,)]
              ),
              inAsyncCall: loadingSpinner,
            ),
            ModalProgressHUD(
              child:  ListView(
                children: pendingEventList.length>0 ? eventCard(pendingEventList) : <Widget>[Container(color: Colors.white,)]
              ),
              inAsyncCall: loadingSpinner,
            ),
          ],
        ),
        floatingActionButton: Builder(builder:(BuildContext context)=>FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context)=>AddNewEvent(widget.userID,widget.userType)
              )).then((value){
                if(value==200){
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Event added successfully."),duration: Duration(seconds: 5),));
                }
                getEventData();
              });
            },
            child: Icon(Icons.add),
          )),
      ),
    );
  }


  
  @override
  Widget build(BuildContext context) {
    return widget.userType=="Admin"?adminBody():normalBody();
  }
}