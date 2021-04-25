import 'package:firebase_auth/firebase_auth.dart';
class AuthMethods
{
    final FirebaseAuth _auth = FirebaseAuth.instance;
      Future signOut() async
      {
        try
        {
          return await _auth.signOut();
        }catch(e)
        {
          print(e.toString());
        }
      }
}

