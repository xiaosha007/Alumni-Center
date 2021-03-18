import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class SpecificAnnouncementPage extends StatefulWidget{
  String announcementID;
  SpecificAnnouncementPage(this.announcementID);
  @override
  State<StatefulWidget> createState() {
    return _SpecificAnnouncementPage();
  }
}

class _SpecificAnnouncementPage extends State<SpecificAnnouncementPage>{

  String userID;
  String publishedDate;
  String title;
  String content;
  bool loadingSpinner = false;


  void getAnnouncementData()async{
    loadingSpinner = true;
    final response = await http.get("http://xiaosha007.hostingerapp.com/getAnnouncement.php?announcementID="+widget.announcementID);
    final resultGet = json.decode(response.body);
    print(resultGet);
    userID = resultGet[0]["UserID"];
    publishedDate = resultGet[0]["PublishDate"];
    title = resultGet[0]["Title"];
    content = resultGet[0]["Content"];
    setState(() {
      loadingSpinner = false;
    });
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
        title:Text("Announcement")
      ),
      body: ModalProgressHUD(
        child: userID==null?Container(color: Colors.white,):
        ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: Text(title,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),
            Container(
              child: Text("Published on "+publishedDate,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
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
              child: Text(content,style: TextStyle(fontSize: 18,fontFamily: 'Acme')),
            ),
          ],
        ),
        inAsyncCall: loadingSpinner,
      ),
    );
  }
}