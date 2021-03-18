import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddNewEvent extends StatefulWidget{
  String userID;
  String userType;
  AddNewEvent(this.userID,this.userType);
  @override
  State<StatefulWidget> createState() {
    return _AddNewEvent();
  }
}

class _AddNewEvent extends State<AddNewEvent>{


  final _formKey = new GlobalKey<FormState>();
  File file;
  String title;
  String description;
  String venue;
  String startTime;
  String endTime;
  String date;
  String status;
  bool loadSpinner = false;
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final FocusNode startTimeFocus = new FocusNode();
  final FocusNode endTimeFocus = new FocusNode();
  final FocusNode dateFocus = new FocusNode();

   @override
  void dispose() {
    startTimeFocus.dispose();
    super.dispose();
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

  void _uploadEvent()async{
    status = widget.userType=="Admin"?"A" : "P";
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
    }
    else return;
    if(file==null){return;}
    setState(() {
      loadSpinner = true;
    });
    String base64Image = base64.encode(file.readAsBytesSync());
    //print(widget.userID);
    //print(base64Image);
    final response = await http.post("http://xiaosha007.hostingerapp.com//addEvent.php",body:{
        "userID" : widget.userID,
        "title" : title,
        "description" : description,
        "venue" : venue,
        "startTime" : startTime,
        "endTime" : endTime,
        "date" : date,
        "status" : status,
        "image" : base64Image
      }).then((res) {
        if(res.statusCode==200){
          loadSpinner = false;
          print("Event added...");
          Navigator.pop(context,res.statusCode);
        }
        else print("Failed to upload event...");
      }).catchError((err) {
        print(err);
      });
    print(response);

  }

  void showTimePicker(String time,TextEditingController controller){
    DatePicker.showTimePicker(context,
            showTitleActions: true,
            onChanged: (date) {
              print('change $date');
            }, 
            onConfirm: (date) {
              print('confirm $date');
              setState(() {
                var converter = new DateFormat('HH:mm:ss');
                String converted = converter.format(date);
                time = converted;
                controller.text = converted;
              });
        }, currentTime: DateTime.now(), locale: LocaleType.en);
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
                date = converted;
                dateController.text = converted;
              });
        }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  @override
  void initState() {
    super.initState();
    startTimeFocus.addListener(
      (){
        if(startTimeFocus.hasFocus){
            setState(() {
            showTimePicker(startTime,startTimeController);
          });
        } 
      }
    );
    endTimeFocus.addListener(
      (){
        if(endTimeFocus.hasFocus){
          setState(() {
           showTimePicker(endTime,endTimeController); 
          });
        }
      }
    );
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
    // TODO: implement build
    return 
    ModalProgressHUD(child:
      Scaffold(
        appBar: AppBar(
          title: Text("Add an event"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: (){_uploadEvent();},
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child:
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom:5),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Title"),
                          validator: (value){
                            if(value.length==0){
                              return "At least write something...";
                            }
                            return null;
                          },
                          onSaved: (input)=>title=input,
                        ), 
                      ), 
                      TextFormField(
                        decoration: InputDecoration(labelText: "Venue"),
                        validator: (value){
                          if(value.length==0){
                            return "At least write something...";
                          }
                          return null;
                        },
                        onSaved: (input)=>venue=input,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Start Time"),
                        focusNode: startTimeFocus,
                        controller: startTimeController,
                        validator: (value){
                          if(value.length==0){
                            return "At least choose something...";
                          }
                          return null;
                        },
                        onSaved: (input)=>startTime=input,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "End Time"),
                        controller: endTimeController,
                        focusNode: endTimeFocus,
                        validator: (value){
                          if(value.length==0){
                            return "At least choose something...";
                          }
                          return null;
                        },
                        onSaved: (input)=>endTime=input,
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom:10),
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
                          onSaved: (input)=>date=input,
                        )
                      ),
                      TextFormField(
                        maxLines: 10,
                        decoration: InputDecoration(labelText: "Event Description",border: OutlineInputBorder(),alignLabelWithHint: true),
                        validator: (value){
                          if(value.length==0){
                            return "At least write something...";
                          }
                          return null;
                        },
                        onSaved: (input)=>description=input,
                      ),
                    ],
                  ),
                ),
            ),
            file!=null?
              Container(
                child: Image.file(file,),
                height: MediaQuery.of(context).size.height*0.2,
              ):Container(color: Colors.white,),  
              Container(
                //width: MediaQuery.of(context).size.width*0.6,
                padding: EdgeInsets.only(right: 30,left: 30),
                child:RaisedButton(
                  color: Colors.blue,
                  onPressed: (){_choose();},
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  child: Text("Click here to upload Event Poster.",style: TextStyle(color: Colors.white,fontSize: 15),),
                ), 
              )
            ],
        ),
      ),
      inAsyncCall: loadSpinner,
    );
  }
}