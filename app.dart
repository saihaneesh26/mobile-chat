
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wpg/auth.dart';
import 'package:wpg/chat.dart';
import'login.dart';
import 'search.dart';
import 'edit.dart';
import 'newsearch.dart';
import 'sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_to_background/move_to_background.dart';
var currentId;
void main()
{
  
  runApp(A1());
}

class A1 extends StatelessWidget{
 FirebaseAuth auth =  FirebaseAuth.instance;
 
  Widget build(BuildContext context)
  {var i=0;
    return WillPopScope(onWillPop: ()async{
      print("back");
     i++;
     print(i);
      if(i==2)
    Navigator.pop(context);
    //    {MoveToBackground.moveTaskToBack();i=0;}
    },
    child: MaterialApp(
      title: "CTZ",
      theme: ThemeData(primaryColor: Colors.orange[400]),
      home: auth.currentUser==null?Login():A2(),
    )
    )
    ;
  }
}
class A2 extends StatefulWidget{
  A2state createState()=>A2state();
}


class A2state extends State<A2>
{
  String name;
  bool isLoading = false;

  var photo;
 var currentName;
 var currentId;
void initState()
{
   isLoading=false;
   
    FirebaseAuth auth =  FirebaseAuth.instance;
    User user = auth.currentUser; 
     try{
   if(FirebaseAuth.instance.currentUser.photoURL==null)
   {
     photo = Icon(Icons.person);
   }
   else
   {
     photo = Image.network(FirebaseAuth.instance.currentUser.photoURL,width: 30,height: 30,);
   }
   currentId=FirebaseAuth.instance.currentUser.uid;
   print("curid"+currentId);
   currentName  = user.displayName;
  }on NoSuchMethodError catch(e)
  {
    currentName=null;
    currentId=null;
  }
   super.initState();
  }
 

   @override
  Widget build(BuildContext cotext) {

  listview(Map l)
{
  return l["me"]?Container(width:0,height:0):GestureDetector(
      child:Container(
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.symmetric(horizontal: 4,vertical: 6),
      decoration: BoxDecoration(border: Border.all(color: Colors.black),color: Colors.lightBlue[200]),
      child:Row(
      children:[
         Container(
           padding: EdgeInsets.all(2),
           margin:EdgeInsets.symmetric(horizontal: 3,vertical: 1),
           child:Icon(Icons.message),
           ),
         Center(child:Text(l["name"],style: TextStyle(fontSize: 24),),)
      ]
    ) 
    ),onTap: (){
       Navigator.push(context,MaterialPageRoute(maintainState: true,builder: (_)=>Mainchat(l["name"],l["Id"],currentId)));
    },
    );
  }



    return isLoading?
      Center(child : CircularProgressIndicator())
    :Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(title: Text(currentName),actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: (){
         Navigator.push(context, MaterialPageRoute(builder:(context)=>NewSearch1() ));
          // Navigator.pop(context);
        },tooltip: "search",),
        IconButton(icon: Icon(Icons.edit), onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>Edit(currentId)));
        }),
        IconButton(icon: Icon(Icons.logout), onPressed:()async 
        {
        
          await new AuthMethods().signOut();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged Out successfully")));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp()));
        },
        tooltip:"Logout",
        ),
       Container(child:photo)
      ],
      ),
      body:DoubleBackToCloseApp(snackBar: const SnackBar(
            content: Text('Tap back again to leave')),
      child: Column(
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
              var currentKey = snapshot.key;
               if(snapshot.key==null)
               return Container(child:Text("......"));
               else{
                Map ct = snapshot.value;
                ct["Id"]= snapshot.key;
                if(currentKey==currentId)
                {
                  ct["me"]=true;
                }
                else
                {
                  ct["me"]=false;
                }
                return listview(ct);
              }}
            ),
          ), 
        )
      ],
      ),
    )
    
    );
  }
}
/*

*/