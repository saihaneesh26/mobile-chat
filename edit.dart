import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wpg/sidebar.dart';
import 'auth.dart';

class edit extends StatelessWidget{
  final currentId;
  edit(this.currentId);
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: "CTZ",
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
  File _image;
         var picker = ImagePicker();
         var image;
         var _imagepath="";
var p="";
  return isLoading?
  Center(child:CircularProgressIndicator())
  :Scaffold(
    drawer: NavigationDrawerWidget(),
    appBar: AppBar(actions: [
      ElevatedButton(onPressed: () async {
        AuthMethods a = new AuthMethods();
        if(c1.text!="") 
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Editing..")));
          setState(() {    
            isLoading=true;
          });
          print(_imagepath+"sd");
         var er = await a.update(c1.text,c2.text,c3.text);
         
          Navigator.pop(context);
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Updated Profile")));
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
        Text("Upload DP"),
        SizedBox(height:5),
        IconButton(icon: Icon(Icons.upload_file), onPressed: () async
        {
           image = await picker.getImage(source: ImageSource.gallery);
           c3.text = image.path;
           print("c3"+c3.text);
          if(image==null)
          {
            return;
          }
          _imagepath = (basename(image.path));
          p+=currentId.toString();
          p+=_imagepath.toString();
          c2.clear();
          c2.text=p;
          print(c2.text);
        }),
      ],),
    )
    )
    ;
}
}

