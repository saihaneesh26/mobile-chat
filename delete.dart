import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'app.dart';
import 'login.dart';

class Delete extends StatelessWidget
{
  
  Widget build(BuildContext context) 
  {
    AlertDialog alert = AlertDialog(
    title: Text("Are you sure to delete your Account"),
    content: Text("All your data will be lost permenantly"),
    actions: [
      ElevatedButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
     },
  ),ElevatedButton(
    child: Text("Delete"),
    onPressed: ()async { 
      await FirebaseDatabase.instance.reference().child("users").child(FirebaseAuth.instance.currentUser.uid).remove();
      await FirebaseAuth.instance.currentUser.delete();
      await GoogleSignIn().signOut();
      Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
    }
  ),
    ],
  );

  return Scaffold(
    appBar: AppBar(),
    body: alert,
  );
  }
}
