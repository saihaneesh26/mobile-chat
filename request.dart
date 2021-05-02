import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wpg/app.dart';
   
Future <void> main()async{
   
  }

class Request extends StatelessWidget{
  final currentId;
Request(this.currentId);
  Widget build(BuildContext context){
  return MaterialApp(
    title: "CTZ",
    home:MyRequests(currentId),
  );
  }
}
class MyRequests extends StatefulWidget{
  final currentId;
MyRequests(this.currentId);
  _State createState()=> _State(currentId);
}

class _State extends State<MyRequests>{
bool isLoading=false;
final currentId;
_State(this.currentId);
  Widget build(BuildContext context)
  {
    return  Scaffold(
      appBar: AppBar(actions: [],title: Text("Requests"),),
      body:Container(
        width: double.infinity,
        child:FirebaseAnimatedList(query: FirebaseDatabase.instance.reference().child("FriendReq").child(currentId), itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index){
            Map c=(snapshot.value);
            if(c.values.first.toString() == "Accept")
            {
              return Row(children: [
                Text(c.keys.first,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 24),maxLines: 3,),
                Spacer(),
                ElevatedButton(onPressed: () async{
                          //currentuser 
                          await FirebaseDatabase.instance.reference().child("users").child(currentId.toString()).update({
                            snapshot.key.toString():"Friends",
                          });
                          //oppuser 
                          await FirebaseDatabase.instance.reference().child("users").child(snapshot.key.toString()).update({
                            currentId:"Friends",
                          
                          });
                          await FirebaseDatabase.instance.reference().child("FriendReq").child(currentId.toString()).child(snapshot.key.toString()).set({
                            c.keys.first:"Accepted"
                          });
                          await FirebaseDatabase.instance.reference().child("FriendReq").child(snapshot.key.toString()).child(currentId.toString()).set({
                            FirebaseAuth.instance.currentUser.displayName:"Accepted"
                          });
                        }, child: Text("Accept")),

              ],);
            }
      
      })));
  }
}