import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wpg/view.dart';
import 'msg.dart';
import 'upload.dart';

class chat extends StatelessWidget{
  final name;String oppId;final currentId;
  chat(this.name,this.oppId,this.currentId);
  Widget build(BuildContext context)
  {
    var i=3;
    return WillPopScope(onWillPop: ()async{
      print("backe");
     i++;
     print(i);
      if(i==5)
    Navigator.pop(context);
    //    {MoveToBackground.moveTaskToBack();i=0;}
    },
    child: MaterialApp(
      title: "CTZ",
      theme: ThemeData(primaryColor: Colors.orange[400]),
      home:Mainchat(name,oppId,currentId)
     ) );
  }
}
class Mainchat extends StatefulWidget{
  final name;
  final oppId;
  final currentId;
  Mainchat(this.name,this.oppId,this.currentId);
  @override
  _State createState(){
    return _State(name,oppId.toString(),currentId);
    }
}

class _State extends State<Mainchat>{
  final name;final oppId;final currentId;
  bool isLoading = false;
  _State(this.name,this.oppId,this.currentId);  
  Query _dbref;
  List doc =[];
void initState() 
{
  setState(() {
    isLoading=false;
  });
  _dbref = FirebaseDatabase.instance.reference().child("messages");
  super.initState();
}  

Widget msgview({Map msg})
{
  // final FirebaseAuth auth =  FirebaseAuth.instance;
  //   User user = auth.currentUser;
  //   final currentuser = user.displayName; 
  //print("My id"+currentId+"  from id"+oppId);
  if(msg["toId"]==currentId && msg["fromId"]==oppId) //recieved to me
  {
    if(msg["ImagePath"]!=null)
    { //print(msg["ImagePath"]);
    return 
    GestureDetector(
      child: Container(
    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
    margin: EdgeInsets.all(3),
    decoration: BoxDecoration(border: Border.all(color: Colors.black,),color: Colors.white),
    child:Text(msg["msg"])
     )
     ,onDoubleTap: () async
     {
       
              setState(() {
                isLoading=true;
              });
       Navigator.push(context,MaterialPageRoute(builder: (builder)=>View(msg["ImagePath"],msg["msg"])));
       
     },
    );
    }

else
   return Container(
    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
    margin: EdgeInsets.all(3),
    decoration: BoxDecoration(border: Border.all(color: Colors.black),color: Colors.white),
    child:Container(
      child:Text(msg["msg"].toString(),maxLines: 10,style: TextStyle(fontSize: 27,color: Colors.black),overflow: TextOverflow.ellipsis,))
     )
   ;
  }



  else if(msg["toId"]==oppId && msg["fromId"]==currentId)
  {
     if(msg["ImagePath"]!=null)
    { return 
    GestureDetector(
      child: Container(
    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
    margin: EdgeInsets.all(3),
    decoration: BoxDecoration(border: Border.all(color: Colors.black),color: Colors.white),
   child:Text(msg["msg"]))
     ,onDoubleTap: () async
     {
       
       Navigator.push(context,MaterialPageRoute(builder: (builder)=>View(msg["ImagePath"],msg["msg"])));
     }
    );
   
    }

    else
   return Container(
    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
    margin: EdgeInsets.all(3),
    decoration: BoxDecoration(border: Border.all(color: Colors.black),color: Colors.black),
    child:Container(
      child:Text(msg["msg"].toString(),maxLines: 10,style: TextStyle(fontSize: 27,color: Colors.white),overflow: TextOverflow.ellipsis,))
     );
  }
  else{
    return Container(width:0,height:0);
  }
 
}

   @override
Widget build(BuildContext context) {
        List _dropvalues = [
        GestureDetector(child:Container(child: Row(children: [
          Icon(Icons.add_photo_alternate),
          Text("Gallery",),
        ],
        ),
        ),onTap: ()async {
          setState(() {
                  isLoading=true;
                });
               // await new Upload().getimage(context,"Gallery",oppId);
                setState(() {
                  isLoading=false;
                });
        },),
        GestureDetector(child:Container(child: Row(children: [
          Icon(Icons.add_a_photo),
          Text("Camera",),
        ],
        ),
        ),onTap: () async{
        setState(() {
                  isLoading=true;
                });
                await new Upload().getimage(context,"Camera",oppId);
                setState(() {
                  isLoading=false;
                });
        },
        ),
        GestureDetector(child:Container(child: Row(children: [
          Icon(Icons.video_library),
          Text("Vedio",),
        ],
        ),
        ),onTap: () async{
        setState(() {
                  isLoading=true;
                });
                await new Upload().getimage(context,"Vedio",oppId);
                setState(() {
                  isLoading=false;
                });
        },
        ),
        GestureDetector(child:Container(child: Row(children: [
          Icon(Icons.upload_file),
          Text("File",),
        ],
        ),
        ),onTap: () async{
        setState(() {
                  isLoading=true;
                });
                await new Upload().getFile(context,"file",oppId);
                setState(() {
                  isLoading=false;
                });
        },
        ),


        ];
    TextEditingController c1 = new TextEditingController();
   
  return  isLoading?
  Center(child: CircularProgressIndicator(),)
  :Scaffold(
    appBar: AppBar(actions: [    

    PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return _dropvalues.map((choice) {
                return PopupMenuItem<String>(
                  child: Container(child: choice,)
                  );
              }).toList();
            },
          ),
        ],title:Text("$name") ,),
    body:Column(children: [
      Container(
        child:Expanded(
          child: FirebaseAnimatedList(query: _dbref, itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index){
            // print(snapshot.value);
              if(snapshot.value==null)
              return Container(child:Text("Say Hi to "+name));
              else{
                Map ct = snapshot.value;
                return msgview(msg:ct);
              }
            }),
    ), 
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(border: Border.all(color: Colors.orange[400])),
        child:TextField(
          controller: c1,
          decoration: InputDecoration(border: OutlineInputBorder(),hintText: "message here...",labelText: "Message",suffixIcon: IconButton(color: Colors.orange[400],icon: Icon(Icons.send),onPressed: (){
           if(c1.text!="")
           {
            //  Message n = new Message(name,c1.text);
             MessageNew mn = new MessageNew(currentId,oppId,c1.text);
            setState(() {
              c1.clear();
            });
            //sendMessage(n);
            sendMessageNew(mn);
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Message sent"),));
          }
          }
          ),
          ),
        )
      )
    ],)
      
    );
  }
}