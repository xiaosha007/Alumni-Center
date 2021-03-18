import 'package:alumni_management_system/editUserProfile.dart';
import 'package:alumni_management_system/uploadProfilePic.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UserProfile extends StatefulWidget {
  String userID;
  UserProfile(this.userID);
  @override
  State<StatefulWidget> createState() {
    return _UserProfile();
  }
}

class _UserProfile extends State<UserProfile> {
  File file;
  Image image;
  String backGroundPicLink = "http://xiaosha007.hostingerapp.com/BackgroundImage/1";
  String profilePicLink = "https://bit.ly/2yMySwm";
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
    http.get("http://xiaosha007.hostingerapp.com/userProfilePic/" + studentID).then(
      (res){
        if(res.statusCode == 200){
          setState(() {
            profilePicLink = "http://xiaosha007.hostingerapp.com/userProfilePic/" + studentID;
            print("Pic get successfully...");
          });
        }
      }
    );
    linkGet = "http://xiaosha007.hostingerapp.com/getAlumniDetails.php?studentID=" + studentID;
    final alumniDetails = await http.get(linkGet);
    final data = json.decode(response.body);
    print(data);
    userName = data[0]["UserName"];
    email = data[0]["Email"];
    country = data[0]["Country"];
    birthday = data[0]["Birthday"];
    if(alumniDetails.statusCode==200){
      final detailsData = json.decode(alumniDetails.body);
      if(detailsData.length>0){
        description = detailsData[0]["Description"];
        mobileNum = detailsData[0]["MobileNum"];
        yearOfGraduation = detailsData[0]["YearOfGraduation"];
        course = detailsData[0]["Course"];
        address = detailsData[0]["Address"];
      }
    }
    print(birthday);
    //print(detailsData);
    if(this.mounted){
       setState(() {
        loadingSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
   // print(profilePicLink);
    return Scaffold(
        appBar: AppBar(
          title: Text("Alumni Center"),
          actions: <Widget>[
            Builder(builder:(BuildContext context)=>
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context)=>EditUserProfile(widget.userID)
                  )).then(
                    (status){
                      if(status == 200){
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Profile edit successfully."),));
                        getUserData();
                      }
                    }
                  );
                },
              )
            )
          ],
        ),
        body: ModalProgressHUD(
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      //color: Colors.orange,
                      child: Image.network(backGroundPicLink,fit: BoxFit.fill),
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
                        color: Colors.black,
                        height: screenWidth * 0.32,
                        width: screenWidth * 0.32,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(screenHeight * 0.2)),
                  Builder(builder: (BuildContext context){
                  return Positioned(
                      top: screenHeight * 0.33,
                      left: screenWidth * 0.58,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child:Container(
                          color:Colors.white,
                          child:IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          UploadProfilePic(widget.userID))).then(
                                            (value){
                                              if(value == 200){
                                                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Picture uploaded successfully"),));
                                                getUserData();
                                              }
                                              // else{
                                              //   Scaffold.of(context).showSnackBar(SnackBar(content: Text("Unexpected error has occurred, please try again."),));
                                              // }
                                            }
                                          );
                                        },
                              )
                            )
                          )
                        )
                      ;})
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    userName != null ? "$userName (" + widget.userID + ")"  : " Unknown",
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                      description != null && description!="default"
                          ? description
                          : "Nothing left by this guy...",
                      style: TextStyle(fontSize: 15)),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.email)),
                        Expanded(
                          child: Text(
                            "Find me at $email",
                            style: TextStyle(fontSize: 20),
                        )
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
                  mobileNum != null && mobileNum!="default"
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
                  address != null && address!="default"
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
                  course != null && course!="default"
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
