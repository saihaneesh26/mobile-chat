import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:move_to_background/move_to_background.dart';
import 'signup.dart';
import 'app.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'networkstats.dart';

void main()
{
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  Widget build(BuildContext context)
  {

    var current = FirebaseAuth.instance.currentUser;
    return  MaterialApp(
      title:"CTZ",
      theme: ThemeData(primaryColor: Colors.orange[400]),
      home:Login()
    );
  }
}
class Login extends StatefulWidget{
  LoginState createState() => LoginState();
}
  class Data
  {
    String username,email;
    Data(this.username,this.email);
  }

class LoginState extends State<Login>{
  final db = FirebaseDatabase.instance;
  String username,password;
  TextEditingController c1 = new TextEditingController();
  TextEditingController c2 = new TextEditingController();
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();

  bool flag=true;
  bool isLoading=false;
  bool login = false;
  bool remember=false;

  String name;

signIn()  async
{
    if(_formKey.currentState.validate())
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
        try
      {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: c1.text,
        password:c2.text);
        setState(() {
            isLoading=false;
        });
        Navigator.push(context,MaterialPageRoute(builder: (context)=>A1()));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("welcome :"+username),));
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading=false;
        });
        if (e.code == 'user-not-found')
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user found for that email.')));
        } else if (e.code == 'wrong-password')
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong password provided for that user..')));
        }
      }
      }

    }
}

  Widget _userName(){
    return TextFormField(
      controller: c1,
      decoration: InputDecoration(hintText:"Email",labelText: "Email"),
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
      onChanged: (String value)
      {
        username=c1.text;
      },
    );
  }

  Widget _password(){
    return TextFormField(
      controller:  c2,
      decoration: InputDecoration(hintText: "Password",
                                  labelText: "Password",
                                  suffixIcon: IconButton(icon:const Icon(Icons.remove_red_eye),
                                                        tooltip: (flag)?"view":"hide",
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

      onChanged: (String value)
      {
        password=c2.text;
      },
    );
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text('Login'),
    ),
    body:DoubleBackToCloseApp(snackBar: SnackBar(content: Text("press again to exit"),
    ),
    child: 
    isLoading?
    Center(
      child: CircularProgressIndicator(),
    )
    :SingleChildScrollView(
      child:Container(
        margin: EdgeInsets.all(24),
        child:Form(
          key: _formKey,
          child: Column(children: <Widget>[
            _userName(),
            _password(),
            Container(
                  child: Column(children: [
                    SizedBox(height: 10,),
                      SignInButton(
                  Buttons.Email,
                  text: "Login with email",
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        isLoading= true;
                      });
                      signIn();
                    }
                  },
                ),
                SizedBox(width:20),
                  SizedBox(),
                  SignInButton(Buttons.GoogleDark, onPressed: ()async{
                   
                      setState(() {
                    isLoading=true;
                  });
                  try{
                  await new AuthMethods().signInWithGoogle();
                   setState(() {
                    isLoading=false;
                  });
                  }on PlatformException catch(e)
                  {
                    
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Try again"),));                  
                  }
                    setState(() {
                    isLoading=false;
                  });
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>A1()));
                  }),

                ElevatedButton(onPressed: ()
                {
                  print("S");
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Signup()),
                );
                }, child: Text("Sign Up Page")
                ),

              ],),
                )
          ],
          ),
        ),
      ),
    ),
    )
    );
  }
}
