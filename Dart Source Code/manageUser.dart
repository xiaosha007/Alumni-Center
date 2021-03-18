import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'manageUserProfile.dart';

class ManageUser extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ManageUser();
  }
} 

class _ManageUser extends State<ManageUser>{

  List userList = List();
  bool loadSpinner = false;

  void getUserData() async{
    loadSpinner = true;
    final response = await http.get("http://xiaosha007.hostingerapp.com/getUserDetails.php?studentID=pending");
    if(response.statusCode==200){
      userList = json.decode(response.body);
    }
    setState(() {
      loadSpinner = false;
    });
  }

  List userCard(){
    return userList.map((user)=>
      Builder(builder:(BuildContext context)=>
        ListTile(
          title: Text(user["UserName"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          leading: Icon(Icons.perm_identity),
          trailing: Icon(Icons.arrow_forward),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context)=>ManageUserProfile(user["UserID"])
            )).then(
              (status){
                if(status==200){
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("User status changed successfully!"),));
                  getUserData();
                }
              }
            );
          },
        )
      )
   ).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pending user list"),
        ),
        body: 
          ListView(
            children: userList.length>0?userCard()
              :<Widget>[Container(color:Colors.white)]
          ),
      ),inAsyncCall: loadSpinner,
    );
  }
}