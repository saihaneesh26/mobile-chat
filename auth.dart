import 'package:firebase_auth/firebase_auth.dart';
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

      Future update(String name,password,url)async
      {
        final currentId = FirebaseAuth.instance.currentUser.uid;
        if(url=="")
        {
          url = FirebaseAuth.instance.currentUser.photoURL;
        }
        try{
          await _auth.currentUser.updateProfile(displayName: name,photoURL:url);
          print("updated"+FirebaseAuth.instance.currentUser.displayName); 
           await FirebaseDatabase.instance.reference().child("users").child(currentId).update({
            "name":name,
            "email":FirebaseAuth.instance.currentUser.email
          });     
          return "updated";  
        }on FirebaseAuthException catch(e)
        {
          print(e);
          return e;
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
  bool old=false;
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
  final db= await FirebaseDatabase.instance.reference().child("users").child(FirebaseAuth.instance.currentUser.uid).update({
                    "name":googleUser.displayName,
                    "email":googleUser.email,
                  }).catchError((onError){

                  });             
  }


  //Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  ); 
  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  on PlatformException catch(e)
  {
    print(e.toString());
  }
}

}