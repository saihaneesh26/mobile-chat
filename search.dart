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
      title: "data",
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
     db = await FirebaseDatabase.instance.reference().child("users").endAt(c1.text).once().then((DataSnapshot snap) async {
    setState(() {
      searchList.clear();
    });
    var keys = snap.value.keys;
      var values = snap.value;
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
                  return Row(
                    // padding: EdgeInsets.all(20),
                    // decoration: BoxDecoration(borderRadius:new BorderRadius.circular(10),color: Colors.green),
                    children :<Widget>[
                      GestureDetector(
                        child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 14),
                        decoration: BoxDecoration(border: new Border.all(width:2,)),
                        child:Center(child:Row(children:<Widget>[
                          Text(searchList[index].name+" : "),
                          Text(searchList[index].email+" "),
                          ElevatedButton(onPressed: () async{
                              Query _dbref;
  List doc =[];
  var currentId;
  
    var document="";
final FirebaseAuth auth =  FirebaseAuth.instance;
    User user = auth.currentUser;
    final currentuser = user.displayName;
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
      if(values[key]["name"]==currentuser)
      {
        //print(key);
        currentId=key;
        doc.add(key.toString());
      }
      if(values[key]["name"]==searchList[index].name)
      {
        //print(key);
        doc.add(key.toString());
       }
       if(doc.length==2)
       {
          doc.sort();
          doc.forEach((element) {
          document+=element;
            });
          print(document);
       // _dbref = FirebaseDatabase.instance.reference().child("messages").child("$document").orderByChild("time");
        // return _dbref;
        doc.clear();
        //print(currentId);
        if(document!="")
        Navigator.push((context),MaterialPageRoute(builder: (context)=>Mainchat(searchList[index].name,document,currentId)));
       }
    }
      }
     ).catchError((e){
       print(e.toString());
     });
   }, child: Text("Message"))
                        ])),
                      ),
                        onTap: (){
                          setState(() {
                            isLoading=true;
                          });
                          Navigator.push((context),MaterialPageRoute(builder: (context)=>A1()));
                        },
                      ),
                      ]);
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
            list(),
          ],
        ),

    )
    );
    
  }
}


/*
 Container(
          child:Column( mainAxisSize: MainAxisSize.min,
          children :<Widget>[
          TextField(
            controller: c1,
            decoration: InputDecoration(labelText: "search",hintText: "Search",suffixIcon: IconButton(icon: Icon(Icons.search),onPressed: (){
              setState(() {
                isLoading=true;
              });
              searchres(c1.text);
            },)
            ),
           ),
          SingleChildScrollView(
            child:Container(
              height: 70,
            padding: EdgeInsets.all(20),
            decoration:BoxDecoration( borderRadius: new BorderRadius.circular(16.0),
            color: Colors.green,),
            child: ListView.builder(itemCount: searchList.length,itemBuilder: (context,index){
             return Text(searchList[index].name.toString());
          }),
          ),
          )])
    )

Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(borderRadius:new BorderRadius.circular(10),color: Colors.green),
                    child:Text(searchList[index].name));


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
            },)
            ),
           ),
             ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:searchList.length,
                itemBuilder: (context,index){
                  return  Text(searchList[index].name);
                })
          ],
        ),




Expanded(
          child: Container(
            child: Column(
            children:<Widget> [
              TextField(
                controller: c1,
                decoration: InputDecoration(labelText: "Search",hintText: "Search Friends",suffixIcon: Icon(Icons.search)),
                
              )
            ],
          ),
          ), )
          
Container(
          child:Column( mainAxisSize: MainAxisSize.min,children :<Widget>[
          TextField(
            controller: c1,
            decoration: InputDecoration(labelText: "search",hintText: "Search",suffixIcon: IconButton(icon: Icon(Icons.search),onPressed: (){
              setState(() {
                isLoading=true;
              });
              searchres(c1.text);
            },)
            ),
           ),
          Container(
            child: ListView.builder(itemCount: searchList.length,itemBuilder: (context,index){
             searchList[index].name.toString();
          }),
          ),
        ])
    )          



Row(
        children: <Widget>[
          Expanded(child: 
          SizedBox(
            height: 200,
            child: ListView.builder(itemCount:searchList.length,itemBuilder: (context,index){
              return Text(searchList[index].name);
            }),
          )
          ),
        ],
        )     
*/