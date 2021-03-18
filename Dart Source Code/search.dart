import 'package:alumni_management_system/searchProfile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class Search extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Search();
  }
}

class _Search extends State<Search>{
  var studentIdList = new List();
  var isSearching = false;
  var searchInput;
  var searchKey = TextEditingController();
  List searchRetrived = new List();
  bool loadSpinner = false;


  Future<void> getSearchData() async{    //to retrive data from database
    if(searchInput!=null){
      loadSpinner = true;
      print("Retrieving search Data....");
      var searchLink = "http://xiaosha007.hostingerapp.com/getSearchResult.php?searchKey="+searchInput;
      final response = await http.get(searchLink);
      searchRetrived =  json.decode(response.body); //return json
      print(searchRetrived);
      print("Data Retrived....");
      setState(() {
        loadSpinner = false;
      });
    }
  }

  _Search(){
     print("Search Constr...");
     searchKey.addListener(
       (){
         if(searchKey.text.isNotEmpty){
           print("IS Typing...");
           setState(() {
            isSearching = true;
            searchInput = searchKey.text;
            getSearchData();
           });
         }
         else{
           setState(() {
            searchInput=""; 
           });
         }
       }
     );
  }
  AppBar appBarBuilder(){
    return AppBar(
      title: TextField(
        controller: searchKey,
        decoration: InputDecoration(
          hintText: "Searching...",
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(Icons.search)
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
            setState(() {
             searchKey.text="";
             searchInput = ""; 
            });
          },
          )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBuilder(),
      body:ModalProgressHUD(child:
        ListView(
          children: searchResult()
        ),
        inAsyncCall: loadSpinner,
      )
    );
  }

  List searchResult(){
    var resultList = List();
    if(searchKey.text.isNotEmpty){
      for(int i=0;i<searchRetrived.length;i++){
        resultList.add(searchRetrived[i]);
      }
      return resultList.map((student)=>ListTile(
          title:Text(student["UserName"]),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context)=>SearchProfile(student["UserID"])
            ));
          },
        )).toList();
    }
    else{
       return resultList.map((student)=>ListTile(
          title:Text(student),
          onTap: (){},
        )).toList();
    }
  }
}