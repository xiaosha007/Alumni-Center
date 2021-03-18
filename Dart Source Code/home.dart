import 'package:alumni_management_system/addFeedback.dart';
import 'package:alumni_management_system/adminReport.dart';
import 'package:alumni_management_system/manageUser.dart';
import 'package:alumni_management_system/search.dart';
import 'package:alumni_management_system/specificAnnouncementPage.dart';
import 'package:alumni_management_system/specificEventPage.dart';
import 'package:alumni_management_system/userAnnouncementList.dart';
import 'package:alumni_management_system/userEventListPage.dart';
import 'package:alumni_management_system/userJobListPage.dart';
import 'package:alumni_management_system/userProfile.dart';
import 'package:alumni_management_system/viewFeedback.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';
import 'loginPage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class HomePage extends StatefulWidget {
  String userID;
  String userType;
  HomePage(this.userID,this.userType);
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  bool loadingSpinner = false;

  List<String> eventPosterList = new List();
  List<String> announcementTitleList = new List();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void getEventData() async{
    eventPosterList.clear();
    loadingSpinner = true;
    final response = await http.get("http://xiaosha007.hostingerapp.com/getEventDetails.php?eventID=all&userID=&upcoming=true");
    final eventList = json.decode(response.body);
    print(eventList);
    for(int i=0;i<eventList.length;i++){
      if(eventList[i]["Status"]=="A"){
        eventPosterList.add("http://xiaosha007.hostingerapp.com/EventPoster/"+eventList[i]["EventID"]);
      }  
    }
    setState(() {
      loadingSpinner = false;
      _refreshController.refreshCompleted();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  void getAnnouncementData() async{
    announcementTitleList.clear();
    final response = await http.get("http://xiaosha007.hostingerapp.com/getAnnouncement.php?announcementID=all");
    final announcementList = json.decode(response.body);
    for(int i=0;i<announcementList.length;i++){
      if(i==6)break;
      announcementTitleList.add(announcementList[i]["AnnouncementID"]);
      announcementTitleList.add(announcementList[i]["Title"]);
    }
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    print("Home build...");
    getEventData();
    getAnnouncementData();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: Scaffold(
        //backgroundColor: Colors.grey[600],
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text("Choose"),
              ),
              ListTile(
                leading: Icon(Icons.search),
                title: Text("Search"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Search()));
                },
              ),
              widget.userID!=null ? ListTile(
                leading: Icon(Icons.event),
                title: Text("Event"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context)=>UserEventListPage(widget.userID,widget.userType)
                  ));
                },
              ):Container(
                color: Colors.white,
              ),
              widget.userID!=null ?Builder(builder:(BuildContext context)=>ListTile(
                leading: Icon(Icons.feedback),
                title: Text("Feedback"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context)=>widget.userType=="Admin"?ViewFeedback():AddFeedback(widget.userID)
                  )).then(
                    (value){
                      if(value==200){
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Feedback submitted"),));
                      }
                    }
                  );
                },)
              ):Container(color: Colors.white,),
              widget.userID!=null ?ListTile(
                leading: Icon(Icons.work),
                title: Text("Job"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context)=>Job(title: "Job List",userID: widget.userID,userType: widget.userType)
                  ));
                },
              ):Container(color: Colors.white,),
              widget.userID!=null && widget.userType=="Admin" ?ListTile(
                leading: Icon(Icons.library_books),
                title: Text("Report"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context)=>AdminReport()
                  ));
                },
              ):Container(color: Colors.white,),
              widget.userID!=null && widget.userType=="Admin" ?ListTile(
                leading: Icon(Icons.notifications),
                title: Text("Announcement"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context)=>UserAnnouncementList(widget.userID,widget.userType)
                  ));
                },
              ):Container(color: Colors.white,),
              widget.userID!=null && widget.userType=="Admin" ?ListTile(
                leading: Icon(Icons.supervised_user_circle),
                title: Text("Manage Users"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context)=>ManageUser()
                  ));
                },
              ):Container(color: Colors.white,),
               widget.userID!=null ?ListTile(
                 leading: Icon(Icons.exit_to_app),
                title: Text("Logout"),
                onTap: () {
                  setState(() {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (BuildContext context)=>HomePage(null, null)
                    ));
                  });
                },
              ):Container(color: Colors.white,),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Alumni Center"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                if(widget.userID!=null){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => UserProfile(widget.userID)));
                }
                else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login()));
                }
              },
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: (){
            getAnnouncementData();
            getEventData();
          },
          child:Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  "Upcoming Events",
                  style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                ),
              ),
              eventPosterList.length>0?
                CarouselSlider(
                  enableInfiniteScroll: true,
                  pauseAutoPlayOnTouch: Duration(seconds: 3),
                  enlargeCenterPage: true,
                  autoPlay: true,
                  viewportFraction: 1.0,
                  items: eventPosterList.map((pictures) {
                    return Builder(builder: (BuildContext context) {
                      return FlatButton(
                        //color: Colors.blue,
                        onPressed: (){
                          String eventID = pictures.replaceAll("http://xiaosha007.hostingerapp.com/EventPoster/", "");
                          print("eventID: "+eventID);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context)=>SpecificEventPage(eventID,widget.userType)
                          ));
                        },
                        child:ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              //margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(color: Colors.white),
                              child: Image.network(pictures,fit: BoxFit.fitWidth,))));
                    });
                  }).toList()):Container(color: Colors.white,),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  "Announcement",
                  style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                ),
              ),
              announcementTitleList.length>0?
              Container(
                  //width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: ListView.builder(
                    itemCount: (announcementTitleList.length/2).round(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Card(
                            color: Colors.red,
                            margin: EdgeInsets.only(right: 20,left: 20,top: 3,bottom: 3),
                            child:ListTile(
                              title: Text(announcementTitleList[(index*2)+1],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                              onTap: (){
                                print('Announcement clicked: '+announcementTitleList[index*2]);
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context)=>SpecificAnnouncementPage(announcementTitleList[index*2])
                                ));
                              },
                            ),
                          ),
                          //Divider(), //                           <-- Divider
                        ],
                      );
                    },
                  )
                ):Container(color: Colors.white,),
                Container(
                  margin: EdgeInsets.all(0),
                  alignment: Alignment.center,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context)=>UserAnnouncementList(widget.userID,widget.userType)
                      ));
                    },
                    child:Text("More announcement",textAlign: TextAlign.center,style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.bold),
                    )
                  ),
                )
            ],
          )
        )
      ),
      inAsyncCall: loadingSpinner,
    );
  }
}
