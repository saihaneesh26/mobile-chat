import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:wpg/search.dart';
import "app.dart";
import 'delete.dart';
import 'search.dart';
import 'edit.dart';
import 'login.dart';




class NavigationDrawerWidget extends StatelessWidget{
  Widget build(BuildContext context) {
  final padding =EdgeInsets.symmetric(horizontal: 20);
  final user = FirebaseAuth.instance.currentUser;
  List <String> items =[
    "Search","Edit Profile","Delete account"
  ];
  List <Icon> ic =[
    Icon(Icons.search,color: Colors.orange[400],),Icon(Icons.edit,color: Colors.orange[400],),Icon(Icons.delete,color: Colors.orange[400])
  ];
  List routes = [
    Search1(),Edit(user.uid),Delete()
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
              Spacer(),
              Container(
                padding: EdgeInsets.all(2),
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                child:Center(
                  child:Text("CTZ -- V1.0.4",style: TextStyle(fontSize: 20),)
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
     photo = Image.network(FirebaseAuth.instance.currentUser.photoURL,width: 30,height: 30,);
   }
  final user = FirebaseAuth.instance.currentUser;
  return Row(children: [
    Container(child:photo),
    SizedBox(height: 10,),
    Container(
      child:Text(user.displayName.toString(),style: TextStyle(fontSize: 24),),
    ),
    Spacer(),
  ],);
}