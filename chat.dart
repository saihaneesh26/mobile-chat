import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'msg.dart';

class chat extends StatelessWidget{
  final name;String document;final currentId;
  chat(this.name,this.document,this.currentId);
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: "Chat",
      theme: ThemeData(primaryColor: Colors.orange[400]),
      home:Mainchat(name,document,currentId)
    );
  }
}
class Mainchat extends StatefulWidget{
  final name;
  final document;
  final currentId;
  Mainchat(this.name,this.document,this.currentId);
  @override
  _State createState(){
    return _State(name,document.toString(),currentId);
    }
}

class _State extends State<Mainchat>{
  final name;final document;final currentId;
  bool isLoading = false;
  _State(this.name,this.document,this.currentId);  
  Query _dbref;
  List doc =[];



void initState() 
{
  setState(() {
    isLoading=false;
  });
  _dbref = FirebaseDatabase.instance.reference().child("messages").child(document) ;

  super.initState();
}  

Widget msgview({Map msg})
{
  // final FirebaseAuth auth =  FirebaseAuth.instance;
  //   User user = auth.currentUser;
  //   final currentuser = user.displayName;
  // print(currentId);
  //   print(currentId==msg["sent"]);
  return currentId!=msg["sent"]?Container(
    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
    margin: EdgeInsets.all(3),
    decoration: BoxDecoration(border: Border.all(color: Colors.black),color: Colors.white),
    child:Text(msg["msg"].toString(),style: TextStyle(fontSize: 27,color: Colors.black),)
    ):Container(
    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
    margin: EdgeInsets.all(3),
    decoration: BoxDecoration(border: Border.all(color: Colors.black),color: Colors.black),
    child:Text(msg["msg"].toString(),style: TextStyle(fontSize: 27,color: Colors.white),)
    );
}

   @override
  Widget build(BuildContext context) {
    TextEditingController c1 = new TextEditingController();
  return isLoading?
  Center(child: CircularProgressIndicator(),)
  :Scaffold(
    appBar: AppBar(actions: [
      IconButton(icon:Icon(Icons.refresh_outlined),onPressed: (){
        // setState(() {
        //   isLoading=true;
        // });
        //initState();
      },),
    ],title:Text("$name") ,),
    body:Column(children: [
      Container(
        child:Expanded(
          child: FirebaseAnimatedList(query: _dbref, itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index){
              if(snapshot.value==null)
              return Container(child:Text("Say Hi to "+name));
              else{
              Map ct = snapshot.value;
              return msgview(msg:ct);
              }
            }),
    ), 
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(border: Border.all(color: Colors.orange[400])),
        child:TextField(
          controller: c1,
          decoration: InputDecoration(border: OutlineInputBorder(),hintText: "message here...",labelText: "Message",suffixIcon: IconButton(color: Colors.orange[400],icon: Icon(Icons.send),onPressed: (){
           if(c1.text!="")
           {
             Message n = new Message(name,c1.text);
            setState(() {
              c1.clear();
            });
            sendMessage(n);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Message sent"),));
          }
          }
          ),
          ),
        )
      )
    ],)      
    );
  }
}
