import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import'main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'chat.dart';
void main()
{
  runApp(Search());
}

class Search extends StatelessWidget{
  Widget build(BuildContext c)
  {
    return MaterialApp(
      title: "CTZ",
      theme: ThemeData(primaryColor: Colors.orange[400]),
      home: Search1(),
    );
  }
}
class Search1 extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class user {
  String name,email;
  user(this.name,this.email);
}

class _SearchState extends State<Search1> {

@override
void initState()
{
  super.initState();
}

  var currentId;
  var text;
  var oppId;
  var alreadyfrd;
  bool isLoading = false;
  String n,e;
  user u;
  final List <user> searchList = [];
  searchres(String text) async {
    if(text.isEmpty)
    {
      setState(() {  
        searchList.clear();
        print("no data");
        isLoading=false;
        }); 
    }
    else{
      var db;
     db = await FirebaseDatabase.instance.reference().child("users").orderByChild("name").startAt(c1.text).limitToFirst(10).once().then((DataSnapshot snap) async {
    setState(() {
      searchList.clear();
    });
    var keys = snap.value.keys;
      var values = snap.value;
      print(values);
      if(snap.value==null)
      {
        
        return;
      }
      
      for(var key in keys)
      {
        u= new user(values[key]['name'],values[key]['email']);
        //print(values[key]['email']);
        searchList.add(u);
      }
      searchList.sort((a,b)=>a.name.compareTo(b.name));
      }
     ).catchError((e){
       print(e.toString());
     });  
     setState(() {
       isLoading=false;
     });  
  }
  }
 list()
{
if(searchList.length==0 || c1.text.isEmpty)
{
  return Container(child:Text("Nousers"));
}
else
 return ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount:searchList.length,
                itemBuilder: (context,index){
                  return Container(
                     padding: EdgeInsets.all(2),
                    // decoration: BoxDecoration(borderRadius:new BorderRadius.circular(10),color: Colors.green),
                    child :
                      GestureDetector(
                        child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 14),
                        decoration: BoxDecoration(border: new Border.all(width:2,)),
                        child:(Row(children:<Widget>[
                          Text(searchList[index].name,style: TextStyle(fontSize: 20),),
                          Spacer(),
                          ElevatedButton(onPressed: () async{
                              Query _dbref;
  List doc =[];
  
  final FirebaseAuth auth = await  FirebaseAuth.instance;
    User user = auth.currentUser;
    var currentId = await auth.currentUser.uid;
print(currentId.toString());
   final db = await FirebaseDatabase.instance.reference().child("users").once().then((DataSnapshot snap)  async {
    var keys = snap.value.keys;
      var values = snap.value;
      if(snap.value==null)
      {
        return "";
      }
      //print(keys);
       for(var key in keys)
    {
     // print(currentuser+name);
     if(user.displayName==values[key]["name"])
      {
        currentId = key;
        print(key);
      } 
      if(searchList[index].name==values[key]["name"])
      {
        oppId = key;
        print(key);
      }   
    }
    if(currentId!=null&&oppId!=null)
      Navigator.push((context),MaterialPageRoute(builder: (context)=>Mainchat(searchList[index].name,oppId,currentId)));
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something is wrong'),));
    }
      }
     ).catchError((e){
       print(e.toString());
     });

   }, child: Text("Message")),
                        ])),
                      ),
                        onTap: (){
                          setState(() {
                            isLoading=true;
                          });
                         // Navigator.push((context),MaterialPageRoute(builder: (context)=>A1()));
                        },
                      ),
                      );
                });
}

  
  TextEditingController c1 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isLoading?
      Center(child: CircularProgressIndicator(),)
    :Scaffold(
      appBar: AppBar(actions: [
      ],title: Text("search"),),
        body: 
SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            TextField(
            controller: c1,
            decoration: InputDecoration(labelText: "search",hintText: "Search",suffixIcon: IconButton(icon: Icon(Icons.search),onPressed: (){
              setState(() {
                isLoading=true;
              });
              searchres(c1.text);
            },
            )
            ),
            onEditingComplete: (){
              setState(() {
                isLoading=true;
              });
              searchres(c1.text);
            },

           ),
           SizedBox(height: 5,),
            list(),
          ],
        ),

    )
    );
    
  }
}
