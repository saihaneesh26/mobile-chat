
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class Message{
  String to,msg;
  Message(this.to,this.msg);
}
///messages
///user
///sent
/// to -> msg

class returnMessage{
  int time;
  String msg;
  returnMessage(this.time,this.msg);
}
 sendMessage(Message msg) async
{
  FirebaseAuth auth =  FirebaseAuth.instance;
    User user = auth.currentUser;
    final from = user.displayName;
    var documentname;
  final db = await FirebaseDatabase.instance.reference().child("users").once().then((DataSnapshot snap) async {
    var keys = snap.value.keys;
      var values = snap.value;
    List a = [];
    var currentId;
    for(var key in keys)
    {
      if(values[key]["name"]==from)
      {
        currentId=key;
        a.add(key);
      }
      if(values[key]["name"]==msg.to)
      {
        a.add(key);
      }
    }
    a.sort();
    if(a.length==2)
    { 
      documentname = a[0].toString()+a[1].toString();
        final dbref = await FirebaseDatabase.instance.reference().child('messages');
        dbref.child(documentname).push().set({
        "time":DateTime.now().millisecondsSinceEpoch.toString(),
        "msg":msg.msg,
        "sent":currentId
      });
      print("Send");
    }
    
  } );
}

class MessageNew{
  String toId,fromId,msg;
  MessageNew(this.toId,this.fromId,this.msg);
}
 sendMessageNew(MessageNew msg) async
{
  FirebaseAuth auth =  FirebaseAuth.instance;
    User user = auth.currentUser;
    final from = user.displayName;
    var sendId;
    var recieveId;
  final db = await FirebaseDatabase.instance.reference().child("users").once().then((DataSnapshot snap) async {
    var keys = snap.value.keys;
      var values = snap.value;
    final dbref = await FirebaseDatabase.instance.reference().child('messages');
        dbref.push().set({
        "time":DateTime.now().millisecondsSinceEpoch.toString(),
        "msg":msg.msg,
        "toId":msg.toId,
        "fromId":msg.fromId
      });//push messages
  });//db
}//end



// getMessage(String p) async
// {
  
// List<returnMessage> msgs =[];
//   DatabaseReference dbref = _needs();
//   FirebaseAuth auth =  FirebaseAuth.instance;
//     User user = auth.currentUser;
//     final currentuser = user.displayName;
//     //sent by our user to person  
    
// await dbref.child(currentuser).orderByChild(p).once().then((DataSnapshot snap) {
//       if(snap.value==null)
//       {
//         return;
//       }
//       var keys = snap.value.keys;
//       var values = snap.value;
//       for(var key in keys)
//       {
//         //print(values);
//         returnMessage m = new returnMessage(values[key]["time"], values[key][p]);
//         msgs.add(m);   
//         print(msgs[0]);
//       }
//       }

//      ).catchError((e){
//        print(e.toString());
//      }); 

//    await   dbref.child(p).orderByChild(currentuser).once().then((DataSnapshot shot){
//         if(shot.value==null)
//       {
//         return null;
//       }
//       var keys = shot.value.keys;
//       var values = shot.value;
//       for(var key in keys)
//       {
//         returnMessage m = new returnMessage(values[key]["time"], values[key][currentuser]);
//         msgs.add(m);
       
//       }
//        return msgs.sort((a,b)=>a.time.compareTo(b.time));
//       }).catchError((onError){
//         print(onError.toString());
//       });
// }
