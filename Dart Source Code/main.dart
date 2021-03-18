import 'package:alumni_management_system/home.dart';
import 'package:flutter/material.dart';

void main()=>runApp(MainApp());

class MainApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(null,null),
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.red,
        fontFamily: 'Grenze'
      ),
    );
  }
}