
import 'package:package_info/package_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wpg/sidebar.dart';

class Report extends StatelessWidget{

  Widget build(BuildContext context)
  {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.orange[400]),
      home:NewReport()
    );
  }

}

class NewReport extends StatefulWidget{
  _state createState()=>_state();

}

class _state extends State<NewReport>{

Widget build(BuildContext context)
{
  var version;

final GlobalKey<FormState> _formKey =  new GlobalKey<FormState>();

TextEditingController c1 = new TextEditingController();
TextEditingController c2 = new TextEditingController();
TextEditingController c3 = new TextEditingController();

  return Scaffold(
    drawer: NavigationDrawerWidget(),
    appBar: AppBar(title: Text("Report"),),
    body: Container(
      decoration: BoxDecoration(border: Border.all(width: 2)),
      padding: EdgeInsets.all(3),
      child:Column(children: [
        Text("REPORT HERE",style: TextStyle(fontSize: 30),),
        TextFormField(
          controller: c1,
          decoration: InputDecoration(border: OutlineInputBorder(),focusColor: Colors.orange,hintText: "Problem",labelText: "Problem"),
        ),
       
        ElevatedButton(onPressed: () async
        {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
           version = packageInfo.version.toString();
          await FirebaseDatabase.instance.reference().child("report").push().set({
            "ReporterId":FirebaseAuth.instance.currentUser.uid,
            "Report":c1.text,
            "Version":version,
            "status":"Submitted",
            "Solution":" "
            ,"time":DateTime.now().millisecondsSinceEpoch
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children:[Text("Thanks for reporting "),Icon(Icons.thumb_up,color: Colors.green,)]),));
        }, child: Text("Report")
        ),
         SizedBox(height: 10,),
         Text("Reported Issues",style: TextStyle(fontSize: 30),),
         Text("all are fixed in latest update"),
         SizedBox(height: 10,),         
        Container(
          // width: double.infinity,
          // decoration: BoxDecoration(color: Colors.red),
          child:Expanded(
          child: FirebaseAnimatedList(query: FirebaseDatabase.instance.reference().child("report").orderByChild("time"), itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index){
            
          if(snapshot.value==null)
          {
            return Text("no reports");
          }
          else{
            Map c = snapshot.value;
            print(c);
           return 
            Container(
              decoration: BoxDecoration(border: Border.all(width: 2)),
              padding: EdgeInsets.all(3),
              child: Column(children: [
                Text("In Version "+c["Version"]),
                Container(
                width: double.infinity, 
                margin: EdgeInsets.all(3),
                padding: EdgeInsets.all(3), 
                decoration: BoxDecoration(border: Border.all()),child:Text(c["Report"],style: TextStyle(fontSize: 20),maxLines: 3,overflow: TextOverflow.ellipsis,)),
                c["status"]=="Submitted"?Icon(Icons.report,color:Colors.red):Icon(Icons.verified,color: Colors.green,),
               Text(c["Solution"],style: TextStyle(),maxLines: 2,)
                ]),
            
            );
          }
         }
        ),
        )
        )
      ],
      )
    ),
  );
}

}
