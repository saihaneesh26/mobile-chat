import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'msg.dart';
import'login.dart';
import 'search.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
 String credential(){
   isLoading=false;
    FirebaseAuth auth =  FirebaseAuth.instance;
    User user = auth.currentUser;
    return user.displayName;
   
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
  Widget messagebox(){
    return Expanded(
      child:Container(
        child:Form(
          key: _formKey,
          child:Column(
          children: <Widget>[
              TextFormField(
                controller: c1,
                decoration: InputDecoration(hintText: "username",labelText: "Username"),
                validator:(String username)
                {
                  if(_formKey.currentState.validate())
                  {
                    return "Username is important";
                  }
                  return null;
                },
            ),
            // SizedBox(height:10),
            TextFormField(
              
              controller: c2,
              decoration: InputDecoration(hintText: "Message",labelText: "Message"),
              validator: (String msg){
                if(_formKey.currentState.validate())
                {
                  return "message is important";
                }
                return null;
              },
            ),
            //SizedBox(height:10),
            ElevatedButton(onPressed: 
            (){
              setState(() {
            isLoading = true;
          });
          send();
            }
            , child: Text("Send"))
          ],
         )
         
    )
    ,padding: EdgeInsets.all(5), decoration:BoxDecoration(border: Border.all(color: Colors.black,),),
    ),
    );
    
  }
  setting()
  {

  }
   @override
  Widget build(BuildContext context) {
    name =credential();
    return isLoading?
      Center(child : CircularProgressIndicator())
    :Scaffold(
      appBar: AppBar(title: Text("Hi $name"),actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: (){
          setState(() {
            isLoading=true;
          });
          Navigator.push(context, MaterialPageRoute(builder:(context)=>Search1() ));
          // Navigator.pop(context);
        },tooltip: "search",),
        IconButton(icon: Icon(Icons.settings), onPressed: setting()),
        IconButton(icon: Icon(Icons.logout), onPressed:() 
        {
          FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged Out successfully")));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
        },
        tooltip:"Logout",
        ),
        
      ],
      ),
      body:Column(children: <Widget>[
        Text("message here"),
        SizedBox(height: 10,),
        messagebox(),

            ],
              ),
            );
          }
}
