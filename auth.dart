import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
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
            "name":name
          });       
        }on FirebaseAuthException catch(e)
        {
          print(e);
        }
      }



Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<UserCredential> signUpWithGoogle() async {
  // Trigger the authentication flow
  final googleUser = await GoogleSignIn().signIn();
   FirebaseDatabase.instance.reference().child("users").child(FirebaseAuth.instance.currentUser.uid).update({
                    "name":googleUser.displayName,
                    "email":googleUser.email,
                  }).catchError((onError){

                  });

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  ); 

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);

}


}