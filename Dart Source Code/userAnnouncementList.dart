import 'package:alumni_management_system/addNewAnnounce.dart';
import 'package:alumni_management_system/specificAnnouncementPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class UserAnnouncementList extends StatefulWidget{
  String userID;
  String userType;
  UserAnnouncementList(this.userID,this.userType);
  @override
  State<StatefulWidget> createState() {
    
    return _UserAnnouncementList();
  }
}

class _UserAnnouncementList extends State<UserAnnouncementList>{

  List announcementDataList = List();
  bool loadingSpinner = false;

  void getAnnouncementData()async{
    loadingSpinner = true;
    announcementDataList.clear();
    final response = await http.get("http://xiaosha007.hostingerapp.com/getAnnouncement.php?announcementID=all");
    final announcementData = json.decode(response.body);
    print(announcementData);
    for(int i=0;i<announcementData.length;i++){
      announcementDataList.add(announcementData[i]);
    }
    setState(() {
      loadingSpinner = false;
    });
  }

  List announcementCard(){
    return announcementDataList.map((announcement)=>
      ListTile(
        title: Text(announcement["Title"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        subtitle: Text("Published on "+ announcement["PublishDate"],style: TextStyle(fontFamily: 'Grenze'),),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context)=>SpecificAnnouncementPage(announcement["AnnouncementID"])
          ));
        },
      )
   ).toList();
  }

  @override
  void initState() {
    super.initState();
    getAnnouncementData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Announcement"),
        elevation: 10.0,
      ),
      body: ModalProgressHUD(
        child:
          ListView(
            children: 
              announcementDataList.length>0?announcementCard() : <Widget>[Container(color: Colors.white,)]
        ),
        inAsyncCall: loadingSpinner,
      ),
      floatingActionButton: widget.userType=="Admin"?Builder(builder:(BuildContext context){
          return FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context)=>AddNewAnnouncement(widget.userID)
            )).then(
              (status){
                if(status == 200){
                  getAnnouncementData();
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Announcement added successfully."),));
                }
              }
            );
          },
          child: Icon(Icons.add),
        );}
        ):Visibility(
          visible: false,
          child: FloatingActionButton(
            onPressed: (){},
            child: Container(color: Colors.white,),
          ),
        )
    );
  }
}