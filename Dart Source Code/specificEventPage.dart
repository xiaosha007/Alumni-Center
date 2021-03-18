import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SpecificEventPage extends StatefulWidget{
  String eventID;
  String userType;
  SpecificEventPage(this.eventID,this.userType);
  @override
  State<StatefulWidget> createState() {
    return _SpecificEventPage();
  }
}

class _SpecificEventPage extends State<SpecificEventPage>{
  String userID = "default";
  String title= "default";
  String description= "default";
  String venue= "default";
  String startTime= "default";
  String endTime= "default";
  String date= "default";
  String status;
  String posterURL;
  bool loadingSpinner = false;


  void getEventData() async{
    loadingSpinner = true;
    print("http://xiaosha007.hostingerapp.com/getEventDetails.php?userID=&upcoming=false&eventID="+widget.eventID);
    final response = await http.get("http://xiaosha007.hostingerapp.com/getEventDetails.php?userID=&upcoming=false&eventID="+widget.eventID);
    http.get("http://xiaosha007.hostingerapp.com/EventPoster/"+widget.eventID).then(
      (res){
        if(res.statusCode==200){
          setState(() {
            posterURL = "http://xiaosha007.hostingerapp.com/EventPoster/"+widget.eventID;
          });
        }
      }
    );
    final eventData = json.decode(response.body);
    print(json.decode(response.body));
    print(eventData);
    userID = eventData[0]["UserID"];
    title = eventData[0]["Title"];
    description = eventData[0]["Description"];
    venue = eventData[0]["Venue"];
    startTime = eventData[0]["StartTime"];
    endTime = eventData[0]["EndTime"];
    date = eventData[0]["Date"];
    status = eventData[0]["Status"];
    print(eventData);
    setState(() {
      loadingSpinner = false;
    });
  }

  void changeEventStatus(bool approved) async{
    String eventStatus;
    print(widget.eventID);
    if(approved){eventStatus="A";}
    else{eventStatus = "D";}
    final response = await http.post("http://xiaosha007.hostingerapp.com/manageEvent.php",body:{
      "eventID":widget.eventID,
      "eventStatus":eventStatus
    });
    if(response.statusCode==200){
      print("Edit successfully!");
      Navigator.pop(context,response.statusCode);
    }
    else{
      print("failed...");
    }
  }

  @override
  void initState() {
    super.initState();
    getEventData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event"),
      ),
      body: ModalProgressHUD(
        child:SingleChildScrollView(child: Center(child:Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.4,
              width: MediaQuery.of(context).size.width,
              child:  Padding(
              padding: EdgeInsets.all(10.0),
              child: posterURL!=null?Image.network(posterURL,fit: BoxFit.fitWidth,):Container(color: Colors.white,),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.all(Radius.circular(25))
              ),
              child:Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(title,style: TextStyle(fontSize: 30.0,color: Colors.redAccent,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  ),
                  Container(
                    margin:EdgeInsets.only(right:40.0,left: 40, bottom: 20),
                    child:Text("Event description: \n "+description,style: TextStyle(fontSize: 17,fontFamily: 'Acme'),textAlign: TextAlign.center,),
                  ),
                  Container(
                    margin:EdgeInsets.only(right:40.0,left: 40, bottom: 20),
                    child:Text("Venue: "+ venue,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  ),
                  Container(
                    margin:EdgeInsets.only(right:40.0,left: 40, bottom: 20),
                    child:Text("Start Time: "+ startTime,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    margin:EdgeInsets.only(right:40.0,left: 40, bottom: 20),
                    child:Text("End Time: "+endTime,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    margin:EdgeInsets.only(right:40.0,left: 40, bottom: 20),
                    child:Text("Date: "+date,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
            widget.userType!="Admin"? 
              Container(
                margin:EdgeInsets.only(right:40.0,left: 40, bottom: 20,top: 30),
                child:Text("Status : "+ (status!="A"?(status!="P"?"Denied":"Pending"):"Approved"),
                        style: TextStyle(fontSize: 17,
                        color: (status!="A"?(status!="P"?Colors.red:Colors.blueAccent):Colors.green),
                        fontWeight: FontWeight.bold),),
              ):Container(
                color: Colors.white,
              ),
            widget.userType=="Admin"&&status=="P"?(
            Center(child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    child: RaisedButton(
                      color: Colors.green,
                      onPressed: (){
                        changeEventStatus(true);
                      },
                      child: Text("Approved"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: RaisedButton(
                      color: Colors.red,
                      onPressed: (){
                        changeEventStatus(false);
                      },
                      child: Text("Declined"),
                    ),
                  )
                ],
              )
            )
            ):Center(child:Container(color: Colors.white,))
          ],
        )
      )),inAsyncCall: loadingSpinner,
      )
    );
  }
}