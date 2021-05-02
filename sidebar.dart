import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:wpg/request.dart';
import 'package:wpg/search.dart';
import "app.dart";
import 'delete.dart';
import 'search.dart';
import 'edit.dart';
import 'login.dart';
import 'newsearch.dart';
import 'report.dart';


class NavigationDrawerWidget extends StatelessWidget{
final info="";
  Widget build(BuildContext context) {
  final padding =EdgeInsets.symmetric(horizontal: 20);
  final user = FirebaseAuth.instance.currentUser;

  List <String> items =[
    "Chat","Search","Requests","Edit Profile","Report a Bug","Delete account"
  ];
  List <Icon> ic =[
    Icon(Icons.chat,color:Colors.orange[400]),Icon(Icons.search,color: Colors.orange[400],),Icon(Icons.add_alert,color: Colors.orange[400],),Icon(Icons.edit,color: Colors.orange[400],),Icon(Icons.report_problem_rounded,color: Colors.orange[400],),Icon(Icons.delete,color: Colors.orange[400])
  ];
  List routes = [
    A1(),NewSearch1(),MyRequests(user.uid),Edit(user.uid),NewReport(),Delete()
      ];
        return Container(
        child: Drawer(
          child: Container(
            child:Column(children: [
              Container(
                padding: EdgeInsets.symmetric(vertical:24).add(EdgeInsets.only(top:MediaQuery.of(context).viewPadding.top)),
                child:buildHeader(),
                width: double.infinity,
                height: 140,
                color: Colors.orange[400],
              ),
              Expanded(child:ListView.builder(
                itemCount: items.length,
                itemBuilder: (context,index){
                return GestureDetector(
                  child:Container(
                  padding: EdgeInsets.all(7),
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(children: [
                    ic[index],
                    SizedBox(width: 10,),
                    Text(items[index],style: TextStyle(fontSize: 28),),
                  ],),
                  ),
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>routes[index]));
                  },
                );
              })
              ),
  
              Container(
                padding: EdgeInsets.all(2),
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                child:Center(
                  child:GestureDetector(
                  child:Text("CTZ Version ",style: TextStyle(fontSize: 20),),onTap: () async{

                  PackageInfo packageInfo = await PackageInfo.fromPlatform();          
                                await ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(packageInfo.version),));
  
                  },
                  )
                )
              )
            ],) ,
          ),
          ),
    
        );
    }
    
}


Widget buildHeader()
{
  var photo;
    if(FirebaseAuth.instance.currentUser.photoURL==null)
   {
     photo = Icon(Icons.person,size: 70,);
   }
   else
   {
     photo = Image.network(FirebaseAuth.instance.currentUser.photoURL,width: 100,height: 100,);
   }
  final user = FirebaseAuth.instance.currentUser;
  return Row(children: [
    Container(child:photo),
    SizedBox(height: 10,),
    Expanded(
      child:Container(
        padding: EdgeInsets.all(1),
        width: double.infinity,
        child: Text(user.displayName.toString(),style: TextStyle(fontSize: 20),maxLines: 2,overflow: TextOverflow.fade,)),
    ),
    Spacer(),
  ],);
}