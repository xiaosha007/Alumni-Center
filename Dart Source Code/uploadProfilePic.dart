import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';


class UploadProfilePic extends StatefulWidget {
  String userID;
  UploadProfilePic(this.userID);

  @override
  State<StatefulWidget> createState() {
    return _UploadProfilePic();
  }
}

class _UploadProfilePic extends State<UploadProfilePic> {
  File file;
  String studentID;
  bool loadSpinner = false;

  void _choose() async {
    //file = await ImagePicker.pickImage(source: ImageSource.camera);
    var _file = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 512,maxWidth: 512)
        .catchError((error) {
      print(error);
    });
    setState(() {
      file = _file;
    });
  }

  Future<int> _upload() async {
    if (file == null) return 0;
    print("Uploading...");
    setState(() {
     loadSpinner=true; 
    });
    String base64Image = base64.encode(file.readAsBytesSync());
    String fileName = studentID;

    final response =await http.post("http://xiaosha007.hostingerapp.com/updateProfilePic.php",
        body: {
          "image": base64Image,
          "fileName": fileName,
        });
    if(response.statusCode==200){
      loadSpinner = false;
      return 200;
    }
    else{
      return 0;
    }
  }



  @override
  Widget build(BuildContext context) {
    studentID = widget.userID;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
       child: Scaffold(
          appBar: AppBar(
            title: Text("Upload Profile Picture"),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Container(
                    child: file != null
                        ? Image.file(
                            file,
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            "https://bit.ly/2yMySwm",
                            fit: BoxFit.fill,
                          ),
                    height: screenWidth * 0.3,
                    width: screenWidth * 0.3,
                  ),
                ),
                RaisedButton(
                  onPressed: _choose,
                  child: Text('Choose Image'),
                ),
                SizedBox(width: 10.0),
                RaisedButton(
                  onPressed: (){
                    _upload().then((value){
                        print("StatusCode: " + value.toString());
                        Navigator.pop(context,value);
                    });
                  },
                  child: Text('Upload Image'),
                )
              ],
            ),
          )
        ),inAsyncCall: loadSpinner,
      );
  }
}
