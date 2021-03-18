import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SearchProfile extends StatefulWidget {
  String userID;
  SearchProfile(this.userID);
  @override
  State<StatefulWidget> createState() {
    return _SearchProfile();
  }
}

class _SearchProfile extends State<SearchProfile> {
  File file;
  Image image;
  String profilePicLink;
  String studentID;
  String userName;
  String email;
  String country;
  String birthday;
  String mobileNum;
  String description;
  String course;
  String address;
  String yearOfGraduation;

  bool loadingSpinner = false;

  @override
  void initState() {
    studentID = widget.userID;
    super.initState();
    getUserData();
  }

  void getUserData() async {
    loadingSpinner = true;
    print("Retrieving user data...");
    var linkGet ="http://xiaosha007.hostingerapp.com/getUserDetails.php?studentID=" + studentID; // get user text information
    final response = await http.get(linkGet);
    final picLink = await http.get("http://xiaosha007.hostingerapp.com/userProfilePic/" + studentID);
    linkGet = "http://xiaosha007.hostingerapp.com/getAlumniDetails.php?studentID=" + studentID;
    final alumniDetails = await http.get(linkGet);
    if(picLink.statusCode == 200){
      profilePicLink = "http://xiaosha007.hostingerapp.com/userProfilePic/" + studentID;
    }
    else{
      profilePicLink = "https://bit.ly/2yMySwm";
    }
    final data = json.decode(response.body);
    if(alumniDetails.statusCode==200){
      final detailsData = json.decode(alumniDetails.body);
      if(detailsData.length>0){
        description = detailsData[0]["Description"];
        mobileNum = detailsData[0]["MobileNum"];
        yearOfGraduation = detailsData[0]["YearOfGraduation"];
        course = detailsData[0]["Course"];
        address = detailsData[0]["Address"];
        print(detailsData);
      }
    }
    userName = data[0]["UserName"];
    email = data[0]["Email"];
    country = data[0]["Country"];
    birthday = data[0]["Birthday"];
    print(data);
    setState(() {
      loadingSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print(profilePicLink);
    return Scaffold(
        appBar: AppBar(
          title: Text("Alumni Center"),
        ),
        body: ModalProgressHUD(
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      //color: Colors.orange,
                      child: Image.network(
                          "https://image.shutterstock.com/image-photo/bright-spring-view-cameo-island-260nw-1048185397.jpg",
                          fit: BoxFit.fill),
                      height: screenHeight * 0.3,
                      width: screenWidth,
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.35,
                    top: screenHeight * 0.2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Container(
                        child: profilePicLink != null
                            ? Image.network(
                                profilePicLink,
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                "https://bit.ly/2yMySwm",
                                fit: BoxFit.fill,
                              ),
                        //alignment: Alignment.center,
                        color: Colors.black,
                        height: screenWidth * 0.3,
                        width: screenWidth * 0.3,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(screenHeight * 0.2)),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    userName != null ? "$userName (" + widget.userID + ")" : " Unknown",
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(description!=null&&description!="default"?description:"This guy is too lazy to write something.",
                      style: TextStyle(fontSize: 15)),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.email)),
                        Text(
                          "Find me at $email",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.public)),
                        Text(
                          "From $country",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(15.0),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.cake)),
                          Text("Born on $birthday",
                              style: TextStyle(fontSize: 20)),
                        ],
                      )),
                  mobileNum != null && course != "default"
                      ? Container(
                          margin: EdgeInsets.all(15.0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(right: 20.0),
                                  child: Icon(Icons.phone)),
                              Expanded(
                                  child: Text("Call me via $mobileNum",
                                      style: TextStyle(fontSize: 20))),
                            ],
                          ))
                      : Container(
                          color: Colors.white,
                        ),
                  address != null && course != "default"
                      ? Container(
                          margin: EdgeInsets.all(15.0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(right: 20.0),
                                  child: Icon(Icons.location_city)),
                              Expanded(
                                  child: Text("Currently at $address",
                                      style: TextStyle(fontSize: 20))),
                            ],
                          ))
                      : Container(
                          color: Colors.white,
                        ),
                  course != null && course != "default"
                      ? Container(
                          margin: EdgeInsets.all(15.0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(right: 20.0),
                                  child: Icon(Icons.school)),
                              Expanded(
                                  child: Text("Studied $course",
                                      style: TextStyle(fontSize: 20))),
                            ],
                          ))
                      : Container(
                          color: Colors.white,
                        ),
                ],
              )
            ],
          ),
          inAsyncCall: loadingSpinner,
        ));
  }
}
