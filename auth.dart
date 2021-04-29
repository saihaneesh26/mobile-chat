import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

import 'login.dart';
class AuthMethods
{
final FirebaseAuth _auth = FirebaseAuth.instance;
      Future signOut() async
      {
        try
        {
          await GoogleSignIn().disconnect();
          await _auth.signOut();
        }catch(e)
        {
          print(e.toString());
        }
      }

      Future update(String name,filename,filepath)async
      {
        final currentId = FirebaseAuth.instance.currentUser.uid;
        if(filename=="")
        {
          await FirebaseDatabase.instance.reference().child("users").child(currentId).update({
            "name":name,
            "dp":FirebaseAuth.instance.currentUser.photoURL,
          });   
          await  FirebaseAuth.instance.currentUser.updateProfile(displayName: name,photoURL: FirebaseAuth.instance.currentUser.photoURL); 
          return; 
        }
        try{
            var _image = File(filepath);
            var uploadTask = FirebaseStorage.instance.ref().child(currentId+"__dp__").putFile(_image);
            await uploadTask.whenComplete((){
              print("uploaded");
            });
            var ref = FirebaseStorage.instance.ref().child(currentId+"__dp__");
            var path = await ref.getDownloadURL();
            print("path "+path);
           await FirebaseDatabase.instance.reference().child("users").child(currentId).update({
            "name":name,
            "email":FirebaseAuth.instance.currentUser.email,
            "dp":path
          });   
          await  FirebaseAuth.instance.currentUser.updateProfile(displayName: name,photoURL: path);   
        }on FirebaseAuthException catch(e)
        {
          print(e);
          return ;
        }
      }



// Future signInWithGoogle() async {
//   // Trigger the authentication flow
//   bool isSigningIn = true;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//   if(googleUser==null)
//   {
//     isSigningIn = false;
//     return;
//   }
//   else{
// try{
//   // Obtain the auth details from the request
//   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//   // Create a new credential
//   final GoogleAuthCredential credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth.accessToken,
//     idToken: googleAuth.idToken,
//   );


//   // Once signed in, return the UserCredential
//   isSigningIn=false;
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }on PlatformException catch(e)
// {
//   print(e.toString());
// }
//   }
// }

Future signInWithGoogle() async {
  // Trigger the authentication flow
  try{
  final googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // 
final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  ); 
  // Once signed in, return the UserCredential
  await FirebaseAuth.instance.signInWithCredential(credential);
  final person = await FirebaseAuth.instance.currentUser;
  bool old=false;
  //final ud = await FirebaseDatabase.instance.reference().child("users").equalTo(person.uid);
    final dbq= await FirebaseDatabase.instance.reference().child("users").once().then((snap){
      var keys = snap.value.keys;
      var values = snap.value;
      for(var key in keys)
      {
        if(values[key]["email"] == googleUser.email)
        {
          old=true;
        }
      }
    });

  if(old==false){
  final db= await FirebaseDatabase.instance.reference().child("users").child(person.uid).update({
                    "name":googleUser.displayName,
                    "email":googleUser.email,
                  }).catchError((onError){

                  });             
  }


  //Obtain the auth details from the request

  // Create a new credential
  
  }
  on PlatformException catch(e)
  {
    print(e.toString());
  }
}

}