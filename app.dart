import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:wpg/chat.dart';
import 'msg.dart';
import'login.dart';
import 'search.dart';
import 'edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
var currentId;
void main()
{
  runApp(A1());
}

class A1 extends StatelessWidget{

  Widget build(BuildContext c)
  {
    return MaterialApp(
      title: "App",
      theme: ThemeData(primaryColor: Colors.orange[400]),
      home: A2(),
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
  var photo =FirebaseAuth.instance.currentUser.photoURL;
 var currentName;
 var currentId=FirebaseAuth.instance.currentUser.uid;
void initState()
{
   isLoading=false;
   super.initState();
   print(photo==null);
    FirebaseAuth auth =  FirebaseAuth.instance;
    User user = auth.currentUser;
   currentName  = user.displayName;
    final db = FirebaseDatabase.instance.reference().child("users").once().then((snap) {
    var keys = snap.value.keys;
    var values = snap.value;
    for (var key in keys)
    {
      if(values[key]["name"]==currentName)
      {
        print(key);
      }
    }
    setState(() {
      name=user.displayName;
    });
    
  });
  }
  send()
  {
    Message msg = new Message(c1.text,c2.text);

    sendMessage(msg);
    setState(() {
        isLoading = false;
      });
      c2.clear();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Message sent successfully to "+c1.text)));
  }
  Widget listview({Map l})
  {

    // return Container(
    //   padding: EdgeInsets.all(2),
    //   margin: EdgeInsets.symmetric(horizontal: 4,vertical: 6),
    //   decoration: BoxDecoration(border: Border.all(color: Colors.black),color: Colors.lightBlue[200]),
    //   child:Row(
    //   children:[
    //      Container(
    //        padding: EdgeInsets.all(2),
    //        margin:EdgeInsets.symmetric(horizontal: 3,vertical: 1),
    //        alignment: Alignment.topCenter,
    //        child:IconButton(icon:Icon(Icons.message,), onPressed: (){
    //         Navigator.push(context,MaterialPageRoute(builder: (context)=>Mainchat(l["name"],l["Id"],currentId)));
    //        },)
    //        ),
    //      Text(l["name"],style: TextStyle(fontSize: 24),),
    //   ]
    // )
    // ,);
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
      appBar: AppBar(title: Text("Hi "+FirebaseAuth.instance.currentUser.displayName),actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: (){
         
          Navigator.push(context, MaterialPageRoute(builder:(context)=>Search1() ));
          // Navigator.pop(context);
        },tooltip: "search",),
        IconButton(icon: Icon(Icons.edit), onPressed: (){
          
        print(currentId);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>Edit(currentId)));
        }),
        IconButton(icon: Icon(Icons.logout), onPressed:() 
        {
          FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged Out successfully")));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
        },
        tooltip:"Logout",
        ),
        photo!=null?Image.network(photo,height: 30,width: 30,):Icons.person
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
