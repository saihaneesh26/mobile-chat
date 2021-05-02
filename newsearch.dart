import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import'main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'chat.dart';
void main()
{
  runApp(NewSearch());
}

class NewSearch extends StatelessWidget{
  Widget build(BuildContext c)
  {
    return MaterialApp(
      title: "CTZ",
      theme: ThemeData(primaryColor: Colors.orange[400]),
      home: NewSearch1(),
    );
  }
}
class NewSearch1 extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class user {
  String name,id,status;
  user(this.name,this.id,this.status);
}



class _SearchState extends State<NewSearch1> {
var currentId= FirebaseAuth.instance.currentUser.uid;
bool isLoading=false;
List <user> userslist =[];

TextEditingController c1 = new TextEditingController();

find(val)async
{
  user u;
  try
{await FirebaseDatabase.instance.reference().child("users").orderByChild("name").startAt(c1.text.toString()).limitToFirst(10).once().then((snap) async {
var keys = snap.value.keys;
  userslist.clear();
var values = snap.value;

for(var key in keys)
{
 if(values[currentId]==null)
{
  userslist.add(new user(values[key]["name"],key.toString(),"no request"));
}
else if(values[currentId][key]==null)
  {
    userslist.add(new user(values[key]["name"],key.toString(),"no request"));
  }
else if(values[currentId][key]=="Pending")
{
  userslist.add(new user(values[key]["name"],key.toString(),"sent"));
}
else if(values[currentId][key]=="Accept")
{
userslist.add(new user(values[key]["name"],key.toString(),"Accept"));
}
else if(values[currentId][key]=="Friends")
  userslist.add(new user(values[key]["name"],key.toString(),"Friends"));
}
userslist.sort((a,b)=>a.name.compareTo(b.name));
print(userslist.first);
});
  }catch(e)
  {
    
  }

setState(() {
  isLoading= false;
});
}



 view() 
{
  if(userslist.length==0)
  return Text("no user");
  return Expanded(
    child:ListView.builder(
              itemCount: userslist.length,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_,index){
                var msg = userslist[index];
                  var oppId = msg.id;
                  var status = msg.status;
                  List a =[currentId,oppId];
                  print("status"+status);
                  // a.sort((a,b)=>a.compareTo(b));
                  // var s = a[0].toString()+a[1].toString();
                  if(status == "no request")
                  {
                    return Container(padding: EdgeInsets.symmetric(horizontal: 16,vertical: 14),
                
                        decoration: BoxDecoration(border: new Border.all(width:2,)),
                        margin:EdgeInsets.all(1),
                      child: Column(children: [
                        Text(msg.name,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 24),maxLines: 3,),
                        //Spacer(),
                        ElevatedButton(onPressed: () async{
                          //currentuser 
                          await FirebaseDatabase.instance.reference().child("users").child(currentId.toString()).update({
                            msg.id:"Pending",
                          });
                          //oppuser 
                          await FirebaseDatabase.instance.reference().child("users").child(msg.id.toString()).update({
                            currentId:"Accept",
                          });
                           await FirebaseDatabase.instance.reference().child("FriendReq").child(msg.id.toString()).child(currentId.toString()).set({
                            FirebaseAuth.instance.currentUser.displayName:"Accept"
                          });
                          await FirebaseDatabase.instance.reference().child("FriendReq").child(currentId.toString()).child(msg.id.toString()).set({
                            msg.name:"Pending"
                          });
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request sent to "+msg.name),));
                        }, child: Text("Request")),
                        ElevatedButton(onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>Mainchat(msg.name.toString(),oppId,currentId)));
                        }, child: Text("Message"))
                      ],),
                    );
                  }
            
                  else if(status == "sent")
                  {
                    return Container(padding: EdgeInsets.symmetric(horizontal: 16,vertical: 14),
                        decoration: BoxDecoration(border: new Border.all(width:2,)),
                        margin:EdgeInsets.all(1),
                      child: Row(children: [
                        Text(msg.name,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 24),maxLines: 3,),
                        //Spacer(),
                        ElevatedButton(onPressed: () async{
                          //currentuser 
                          await FirebaseDatabase.instance.reference().child("users").child(currentId.toString()).child(msg.id).remove();
                          //oppuser 
                          await FirebaseDatabase.instance.reference().child("users").child(msg.id.toString()).child(currentId).remove();
                          await FirebaseDatabase.instance.reference().child("FriendReq").child(msg.id.toString()).child(currentId.toString()).remove();
                          await FirebaseDatabase.instance.reference().child("FriendReq").child(currentId.toString()).child(msg.id.toString()).remove();
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg.name+"'s request Cancelled"),));
                        }, child: Text("Cancel")),
                        ElevatedButton(onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>Mainchat(msg.name.toString(),oppId,currentId)));
                        }, child: Text("Message"))
                      ],),
                    );
                  }
                  else if(status == "Accept")
                  {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 14),
                        decoration: BoxDecoration(border: new Border.all(width:2,)),
                        margin:EdgeInsets.all(1),
                      child: Row(children: [
                        Text(msg.name,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 24),maxLines: 3,),
                       // Spacer(),
                        ElevatedButton(onPressed: () async{
                          //currentuser 
                          await FirebaseDatabase.instance.reference().child("users").child(currentId.toString()).update({
                            msg.id:"Friends",
                          });
                          //oppuser 
                          await FirebaseDatabase.instance.reference().child("users").child(msg.id.toString()).update({
                            currentId:"Friends",
                          
                          });
                          await FirebaseDatabase.instance.reference().child("FriendReq").child(msg.id.toString()).child(currentId.toString()).set({
                            FirebaseAuth.instance.currentUser.displayName:"Accepted"
                          });
                          await FirebaseDatabase.instance.reference().child("FriendReq").child(currentId.toString()).child(msg.id.toString()).set({
                            msg.name:"Accepted"
                          });
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg.name+"'s request accepted"),));
                        }, child: Text("Accept")),
                        ElevatedButton(onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>Mainchat(msg.name.toString(),oppId,currentId)));
                        }, child: Text("Message"))
                      ],),
                    );
                  }
                  else if(status == "Friends")
                  {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 14),
                        decoration: BoxDecoration(border: new Border.all(width:2,)),
                        margin:EdgeInsets.all(1),
                      child: Row(children: [
                       Text(msg.name,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 24),maxLines: 3,),
                        ElevatedButton(onPressed: () async{
                          //currentuser 
                          await FirebaseDatabase.instance.reference().child("users").child(currentId.toString()).child(msg.id).remove();
                          //oppuser 
                          await FirebaseDatabase.instance.reference().child("users").child(msg.id.toString()).child(currentId).remove();
                          await FirebaseDatabase.instance.reference().child("FriendReq").child(msg.id.toString()).child(currentId.toString()).remove();
                          await FirebaseDatabase.instance.reference().child("FriendReq").child(currentId.toString()).child(msg.id.toString()).remove();
                        }, child: Text("Unfriend")),
                        ElevatedButton(onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>Mainchat(msg.name.toString(),oppId,currentId)));
                        }, child: Text("Message"))
                      ],),
                    );
                  }
                }));
       
}

var c1val="a";
GlobalKey _globalKey = new GlobalKey();
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search"),),
      body: Container(child: Column(children: [
        TextFormField(
          controller: c1,
          key: _globalKey,
          decoration: InputDecoration(suffixIcon: IconButton(icon: Icon(Icons.search),onPressed: (){

          },)),
          onFieldSubmitted: (e) async{
            print(c1.text);
            setState(() {
              isLoading=true;
            });
           await find(c1.text);
          },
        ),
        isLoading?Center(child: CircularProgressIndicator(),):view(),
      ],
      ),
      ),
    );
  }

}
