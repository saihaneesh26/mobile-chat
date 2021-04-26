import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'auth.dart';

class edit extends StatelessWidget{
  final currentId;
  edit(this.currentId);
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: "Edit",
      home:Edit(currentId),
      theme: ThemeData(primaryColor: Colors.orange[400]),
    );
  }
}

class Edit extends StatefulWidget{
  final currentId;
  Edit(this.currentId);
  _State createState()
  {
    return _State(currentId);
  }
}

class _State extends State<Edit>{
final currentId;
_State(this.currentId);
TextEditingController c1 = new TextEditingController();
TextEditingController c2 = new TextEditingController();
TextEditingController c3 = new TextEditingController();
bool isLoading=false;

var name;

void initState()
{
  super.initState();
  var auth = FirebaseAuth.instance.currentUser;
  c1.text = auth.displayName;
}


Widget build(BuildContext context)
{
  return isLoading?
  Center(child:CircularProgressIndicator())
  :Scaffold(
    appBar: AppBar(actions: [
      ElevatedButton(onPressed: () async {
        AuthMethods a = new AuthMethods();
        if(c1.text!="") 
        {
          setState(() {
            isLoading=true;
          });
          var er =a.update(c1.text, c2.text,c3.text);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("d")));
          setState(() {
            isLoading=false;
          });
        }

      }, child: Text("Save"),)
    ],title:Text("Edit",),),
    body: Container(
      height: double.infinity,
      padding: EdgeInsets.all(3),
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(border: Border.all(color: Colors.black),),
      child: Column(children: [
        TextFormField(
          controller:c1,
          scrollPadding: EdgeInsets.all(10),
          decoration: InputDecoration(border: OutlineInputBorder(gapPadding: 2),hintText: "Username",labelText: "Username"),
        ),
        SizedBox(height:10),
        TextFormField(
          controller:c2,
          scrollPadding: EdgeInsets.all(10),
          decoration: InputDecoration(border: OutlineInputBorder(gapPadding: 2),hintText: "password",labelText: "Fill to change password"),
        ),
        SizedBox(height:10),  
        TextFormField(
          controller:c3,
          decoration: InputDecoration(border: OutlineInputBorder(gapPadding: 2),hintText: "DP URL",labelText: "Dp URL"),
        )
      ],),
    )
  );
}
}

