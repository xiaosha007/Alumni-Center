import 'package:flutter/material.dart';
import './jobDetails.dart';
import './specificJobPage.dart';
import './addNewJob.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';

class Job extends StatefulWidget {
  Job({Key key, this.title,this.userID="1171101755",this.userType="Admn"}) : super(key: key);
  String userID;
  String userType;
  final String title;
  @override
  State<StatefulWidget> createState() => _JobState();
}

class _JobState extends State<Job> {
  List allJobs=List();
  String image;
  bool loadingSpinner = false;
  @override
  void initState(){
    getJobDetails();
    super.initState();
  }
  void getJobDetails() async{  //retrive event from hosting server
    loadingSpinner = true;
    allJobs.clear();
    final response = await http.get("http://xiaosha007.hostingerapp.com/getJobDetails.php?jobID=all");
    final data = json.decode(response.body);
    for(int i=0;i<data.length;i++){
      
      image = "http://xiaosha007.hostingerapp.com/JobPoster/"+data[i]["JobID"];
      JobDetails temp= JobDetails(url: image, jobID: data[i]["JobID"],userID: data[i]["UserID"],jobTitle: data[i]["JobTitle"],company: data[i]["CompanyName"],description: data[i]["JobRequirements"],salary: data[i]["MonthlySalary"],datePosted: data[i]["DatePosted"],dateExpiry: data[i]["DateExpiry"]);
      allJobs.add(temp);
      print(temp.description);
    }
    setState(() {
      loadingSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: topAppBar,
      body: ModalProgressHUD(
        child: allJobs.length>0 ? makeBody(allJobs,context): Container(color: Colors.white,),
        inAsyncCall: loadingSpinner,
      ),
      floatingActionButton: widget.userType=="Admin"?FloatingActionButton(
        onPressed: _addJob,
        tooltip: 'Post a job',
        child: Icon(Icons.add),
      ):Visibility(
        visible: false,
        child: FloatingActionButton(
          onPressed: null,
        ),
      ), // This traili
    );
  }
  void _addJob (){
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context)=> newJob(widget.userID)
    )).then((value){
      getJobDetails();
    }
  );  
  }
}

final topAppBar = AppBar(
    elevation: 0.1,
    title: Text('Job List'),
  );


Container makeBody(List allJobs,BuildContext context) => Container(
  child: 
  ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: allJobs.length,
    itemBuilder: (BuildContext context, int index) {
      return makeCard(allJobs[index],context);
    },
  ),
);

Card makeCard (JobDetails job,BuildContext context) => Card(
  elevation: 8.0,
  margin: new EdgeInsets.symmetric(horizontal:10.0, vertical:6.0),
  child: Container(
    decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
    child: makeListTile(job,context),
  ),
);


ListTile makeListTile(JobDetails job,BuildContext context) => ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => specificJobPage(job: job)));
      },
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
          border: new Border(
            right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: SizedBox(
          width:70.0,
          height:70.0,
          child:Image.network(job.url,fit: BoxFit.contain),
        )
        //child: Icon(Icons.autorenew, color: Colors.white),
      ),
      title: Text(
        job.jobTitle!=null ? job.jobTitle: "Title",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Icon(Icons.linear_scale, color: Colors.yellowAccent),
          Expanded(child:Text(job.salary!=null? job.salary : "Salary", style: TextStyle(color: Colors.white)))
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));

List getJob() {
  return [
    JobDetails(
      url: "https://upload.wikimedia.org/wikipedia/commons/b/ba/CMA_CGM_Company_Logo_July_2017.png",
      jobID: "1",
      userID: "1171101755",
      jobTitle: "Data Analyst",
      company: "Maybank Sdn Bhd",
      description: "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed.",
      salary: "RM 2200 - RM 3200",
      dateExpiry: "31 December 2019",
      datePosted: "1 January 2019"
    ),
    JobDetails(
      url: "https://seeklogo.com/images/R/rounded-design-company-logo-58FEBA6563-seeklogo.com.png",
      jobID: "2",
      userID: "1171101755",
      jobTitle: "Budget Analyst",
      company: "Maybank Sdn Bhd",
      description: "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed.",
      salary: "RM 22000 - RM 32000",
      dateExpiry: "31 December 2019",
      datePosted: "1 January 2019"
    ),
    JobDetails(
      url: "https://www.designevo.com/res/templates/thumb_small/blue-and-yellow-mansion.png",
      jobID: "3",
      userID: "1171101755",
      jobTitle: "Software Developer Managing Director",
      company: "Maybank Sdn Bhd",
      description: "Miusov, as a man man of breeding and deilcacy, could not but feel some inwrd qualms, when he reached the Father Superior's with Ivan: he felt ashamed of havin lost his temper. He felt that he ought to have disdaimed that despicable wretch, Fyodor Pavlovitch, too much to have been upset by him in Father Zossima's cell, and so to have forgotten himself. Teh monks were not to blame, in any case, he reflceted, on the steps. And if they're decent people here (and the Father Superior, I understand, is a nobleman) why not be friendly and courteous withthem? I won't argue, I'll fall in with everything, I'll win them by politness, and show them that I've nothing to do with that Aesop, thta buffoon, that Pierrot, and have merely been takken in over this affair, just as they have. He determined to drop his litigation with the monastry, and relinguish his claims to the wood-cuting and fishery rihgts at once. He was the more ready to do this becuase the rights had becom much less valuable, and he had indeed the vaguest idea where the wood and river in quedtion were. he enterd the Father Superior ",
      salary: "RM 100 - RM 200",
      dateExpiry: "31 December 2019",
      datePosted: "1 January 2019")
  ];
}

