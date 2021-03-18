import 'package:flutter/material.dart';
import './jobDetails.dart';

class specificJobPage extends StatelessWidget {
  final JobDetails job;
  specificJobPage({Key key, this.job}) { 
    //super(key: key);
    print(job.jobTitle);
    print(job.userID);
    print(job.jobID);
    print(job.company);
    print(job.description);
    print(job.salary);
    print(job.dateExpiry);
    print(job.datePosted);
  }
  @override
  Widget build(BuildContext context) {

    final topContent = Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      padding: EdgeInsets.fromLTRB(40,20,40,20),
      child:Row(children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(job.jobTitle, style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold))
              ),
              Container(
                padding: EdgeInsets.fromLTRB(14.0, 0, 0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(job.company, style: TextStyle(fontSize: 16.0,height: 2.0),),
                    Text("posted on "+job.datePosted, style: TextStyle(fontSize: 12.0,fontStyle: FontStyle.italic,fontFamily: 'Acme')),
                    Text(job.salary, style: TextStyle(fontSize: 16.0,height:2)),
                  ]
                )
              ),
            ]
          ),
        ),
        Expanded(
          child:Container(
            margin: EdgeInsets.all(20),
            //padding: EdgeInsets.all(20.0),
            child: FittedBox(
              child: Image.network(job.url,fit: BoxFit.fill )
            )
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      //crossAxisAlignment: CrossAxisAlignment.center,
      )
    );

    final bottomContent = Expanded (child: SingleChildScrollView(child: Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      padding: EdgeInsets.fromLTRB(40,0,40,40),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Text("Job Requirements", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'Acme' )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(12.0),
              decoration: new BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.blue)
              ),
              child: Text(
                job.description,
                style: TextStyle(fontSize: 18.0)
              )
            ),
          ]
        ),
      ),
    )));
    final deadLine = Container (
      padding : EdgeInsets.only(top: 10.0),
      child: Text("Application Deadline ", style: TextStyle(fontSize: 20.0,fontStyle: FontStyle.italic)),
    );
    final expiryDate = Container(
      padding : EdgeInsets.only(bottom: 20.0),
      child: Text(job.dateExpiry, style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Job Details"),
      ),
      body: Column(
        children: <Widget>[topContent,bottomContent, deadLine, expiryDate],
      ),
    );
  }
}