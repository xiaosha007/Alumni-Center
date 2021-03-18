import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class newJob extends StatefulWidget{
  String userID;  
  newJob(this.userID);
  @override
  State<StatefulWidget> createState() {
    return _newJob();
  }
}

class _newJob extends State<newJob>{
  String title;
  String company;
  String salary;
  String expiryDate;
  String description;
  bool loadSpinner = false;
  File file;
  final FocusNode dateFocus = new FocusNode();
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();

  void _uploadJob()async{
    //status = widget.userType=="Admin"?"A" : "P";
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      setState(() {
        loadSpinner = true;
      });
    }
    else return;
    if(file==null){return;}
    DateTime now = new DateTime.now();
    var converter = new DateFormat('yyyy-MM-dd');
    String datePosted = converter.format(now);
    String base64Image = base64.encode(file.readAsBytesSync());
    
    final response = await http.post("http://xiaosha007.hostingerapp.com/addJob.php",body:{
        "userID" : widget.userID,
        "jobTitle" : title,
        "companyName" : company,
        "jobRequirements" : description,
        "monthlySalary" : salary,
        "datePosted" : datePosted,
        "dateExpiry" : expiryDate,
        "image" : base64Image
      }).then((res) {
        if(res.statusCode==200){
          print("Job added...");
          setState(() {
            loadSpinner = false;
            Navigator.pop(context,res.statusCode);
          }); 
        }
        else print("Failed to upload event...");
      }).catchError((err) {
        print(err);
      });

    print(response);
  }

  void _choose() async {
    var _file = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 512,maxWidth: 512)
        .catchError((error) {
      print(error);
    });
    setState(() {
      file = _file;
    });
  }

  void showDatePicker(){
    DatePicker.showDatePicker(context,
            showTitleActions: true,
            onChanged: (date) {
              print('change $date');
            }, 
            onConfirm: (Date) {
              print('confirm $Date');
              setState(() {
                var converter = new DateFormat('yyyy-MM-dd');
                String converted = converter.format(Date);
                expiryDate = converted;
                dateController.text = converted;
              });
        }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  @override
  void initState() {
    super.initState();
    dateFocus.addListener(
      (){
        if(dateFocus.hasFocus){
          setState(() {
           showDatePicker(); 
          });
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(child:
      Scaffold(
        appBar: AppBar(
          title: Text("Add Job"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: (){
                _uploadJob();
              },
            )
          ],
        ),
        body: ListView(
              padding: EdgeInsets.all(40.0),
              children: <Widget>[Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                        decoration: InputDecoration(labelText: "Job Title"),
                        validator: (value){
                          if(value.length==0){
                            return "Please fill up this field";
                          }
                          return null;
                        },
                        onSaved: (input)=>title=input,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Company Name"),
                        validator: (value){
                          if(value.length==0){
                            return "Please fill up this field";
                          }
                          return null;
                        },
                        onSaved: (input)=>company=input,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Salary"),
                        validator: (value){
                          if(value.length==0){
                            return "Please fill up this field";
                          }
                          return null;
                        },
                        onSaved: (input)=>salary=input,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child:TextFormField(
                          decoration: InputDecoration(labelText: "Date"),
                          focusNode: dateFocus,
                          controller: dateController,
                          validator: (value){
                            if(value.length==0){
                              return "At least choose something...";
                            }
                            return null;
                          },
                          onSaved: (input)=>expiryDate=input,
                        ),
                      ),
                      TextFormField(
                        maxLines: 10,
                        decoration: InputDecoration(labelText: "Description/Requirements",border: OutlineInputBorder(),alignLabelWithHint: true),
                        validator: (value){
                          if(value.length==0){
                            return "Please fill up this field";
                          }
                          return null;
                        },
                        onSaved: (input)=>description=input,
                      ),
                      file!=null?
                      Center(
                        child:Container(
                          padding: EdgeInsets.all(20.0),
                          child: Image.file(file,),
                          height: MediaQuery.of(context).size.height*0.2,
                        )
                      )
                      : Container(color: Colors.white,),  
                      
                      Center(child:Container(
                        //padding: EdgeInsets.only(top: 20),
                        child:RaisedButton(
                          color: Colors.blue,
                          onPressed: (){_choose();},
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          child: Text("Click here to upload Company Logo.",style: TextStyle(color: Colors.white,fontSize: 15),),
                        ),
                      )
                      )
                  ],
                ),
              ),
            ]
          )
      ),
      inAsyncCall: loadSpinner,
    );
  }
}
