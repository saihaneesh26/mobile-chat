import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import "app.dart";
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'networkstats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
Future <void> main() async{ 
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  }

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbapp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CTZ',
      theme: ThemeData(
        primaryColor: Colors.orange[400],
      ),
      home:FutureBuilder(future: _fbapp,
          builder: (context,snapshot){
            if(snapshot.hasError)
            {
              return Text("some thing is wrong");
            }
            else if(snapshot.hasData)
            {
              return Signup();
            }
            else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },),
    );
  }
}

class Signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<Signup> {
  
  String _name;
  String _email;
  String _password;
  bool stats = network_stats();
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  
  TextEditingController c1= new TextEditingController();
  TextEditingController c2= new TextEditingController();
  TextEditingController c3= new TextEditingController();
  
  bool flag=true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    
    return TextFormField(
      controller: c1,
      decoration: InputDecoration(labelText: 'Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      controller: c2,
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      
    );
  }

  Widget _buildPassword(){
    return TextFormField(
      controller: c3,
      decoration: InputDecoration(hintText: "Password",
                                  labelText: "Password",
                                  suffixIcon: IconButton(icon:const Icon(Icons.remove_red_eye),
                                                        tooltip: "",
                                                        onPressed: (){
                                                          setState((){
                                                            if(flag==true)flag=false;
                                                            else flag=true;
                                                          });
                                                        },
                                                        ),
                                  ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'password is Required';
        }
        return null;
      },
     
      obscureText:flag,
    );
  }

signUp() async
{
  bool stats = network_stats();
      if(stats)
      {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No network")));
      setState(() {
            isLoading=false;
        });
      }
      else
      {
        try {
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: c2.text,
              password:c3.text
    );
    final db = FirebaseDatabase.instance.reference();
    db.child("users").child(userCredential.user.uid).set({"name":c1.text,"email":c2.text});
    final user = FirebaseAuth.instance.currentUser;
    user.updateProfile(displayName:c1.text);
    setState(() {
      isLoading=false;
    });
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Login()));
  } on FirebaseAuthException catch (e) {
    setState(() {
      isLoading=false;
    });
    if (e.code == 'weak-password') 
    { 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The password provided is too weak.')));
    } else if (e.code == 'email-already-in-use') 
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The account already exists for that email.')));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  }
      }

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body:isLoading?
    Container(
      child:Center(child: CircularProgressIndicator(),)
    )
    :SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildName(),
                _buildEmail(),
                _buildPassword(),
                Container(
                  child: Column(children: [
                    SizedBox(height: 10,),
                      SignInButton(
                  Buttons.Email,
                  text: "Sign Up with email",
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        isLoading= true;
                      });
                      signUp();
                    }
                  },
                ),
                SizedBox(width:20),
               SignInButton(
                Buttons.GoogleDark,
                text: "Sign Up with Google",
                onPressed: ()
                {
                  authMethods.signInWithGoogle();
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
                }),

                ElevatedButton(onPressed: ()
                {
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
                }, child: Text("Login Page")),
              ],),
                ),
                
                SizedBox(height:10), 

              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
final ref = db.reference().child("users");
                     ref.push().set({
                       "username":_name,
                       "email":_email,
                       "password":_password
                     }).then((_) {
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
                          ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Successfully SignedUp')));
                              
                        });
                        */