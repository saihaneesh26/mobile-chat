import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wpg/chat.dart';
import 'msg.dart';
import'login.dart';
import 'search.dart';
import 'edit.dart';
import 'sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
var currentId;
void main()
{
  
  runApp(A1());
}

class A1 extends StatelessWidget{
 FirebaseAuth auth =  FirebaseAuth.instance;
  Widget build(BuildContext c)
  {
    return MaterialApp(
      title: "CTZ",
      theme: ThemeData(primaryColor: Colors.orange[400]),
      home: auth.currentUser==null?Login():A2(),
    );
  }
}
class A2 extends StatefulWidget{
  A2state createState()=>A2state();
}


class A2state extends State<A2>
{
  String name;
  bool isLoading = false;
  TextEditingController c1 = new TextEditingController();
  TextEditingController c2 = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  var photo;
 var currentName;
 var currentId;
void initState()
{
   isLoading=false;
   
    FirebaseAuth auth =  FirebaseAuth.instance;
    User user = auth.currentUser; 
     try{
   photo =FirebaseAuth.instance.currentUser.photoURL;
   currentId=FirebaseAuth.instance.currentUser.uid;
   currentName  = user.displayName;
  }on NoSuchMethodError catch(e)
  {
    photo ="";
    print("d"+photo.toString()=="");
    currentName=null;
    currentId=null;
  }
   super.initState();
  }
  Widget listview({Map l})
  {
    return GestureDetector(
      child:Container(
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.symmetric(horizontal: 4,vertical: 6),
      decoration: BoxDecoration(border: Border.all(color: Colors.black),color: Colors.lightBlue[200]),
      child:Row(
      children:[
         Container(
           padding: EdgeInsets.all(2),
           margin:EdgeInsets.symmetric(horizontal: 3,vertical: 1),
           alignment: Alignment.topCenter,
           child:Icon(Icons.message),
           ),
         Text(l["name"]+(l["me"]?" (me)":""),style: TextStyle(fontSize: 24),),
      ]
    ) 
    ),onTap: (){
       Navigator.push(context,MaterialPageRoute(builder: (context)=>Mainchat(l["name"],l["Id"],currentId)));
    },
    );
  }


   @override
  Widget build(BuildContext context) {
    return isLoading?
      Center(child : CircularProgressIndicator())
    :Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(title: Text(currentName),actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: (){
         
          Navigator.push(context, MaterialPageRoute(builder:(context)=>Search1() ));
          // Navigator.pop(context);
        },tooltip: "search",),
        IconButton(icon: Icon(Icons.edit), onPressed: (){
       // print("url"+FirebaseAuth.instance.currentUser.photoURL.toString());
        //print(currentId);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>Edit(currentId)));
        }),
        IconButton(icon: Icon(Icons.logout), onPressed:() 
        {
          FirebaseAuth.instance.signOut();
          GoogleSignIn().disconnect();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged Out successfully")));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
        },
        tooltip:"Logout",
        ),
        Container(child:photo.toString() == null ?Icon(Icons.person_outline_sharp):Image.network(photo.toString(),height: 30,width: 30,))
      ],
      ),
      body:Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(color: Colors.orange[400]),
          margin: EdgeInsets.symmetric(horizontal: 0,vertical:0),
          child:Text("Chats",style: TextStyle(fontSize: 30,color: Colors.black),),),
        SizedBox(height: 10,),
        Container(
          child:Expanded(
            child: FirebaseAnimatedList(query: FirebaseDatabase.instance.reference().child("users").orderByChild("name"), itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index){
              //print(snapshot.value);
              var currentKey = snapshot.key;
             // print(currentKey);
              if(snapshot.value==null)
              return Container(child:Text("......"));
              else{
                Map ct = snapshot.value;
                ct["Id"]= currentKey;
                if(currentKey==currentId)
                {
                  ct["me"]=true;
                }
                else
                {
                  ct["me"]=false;
                }
                return listview(l:ct);
              }
            }),
          ), 
        )
      ],
      ),
    );
  }
}
