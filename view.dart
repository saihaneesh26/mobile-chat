import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  
 
}

class VIew extends StatelessWidget{
  final url,name;
  VIew(this.url,this.name);
  
 
  Widget build(BuildContext context){
return MaterialApp(
      theme: ThemeData(primaryColor: Colors.orange[400]),
      home:View(url,name)
);
  }
}

class View extends StatefulWidget{
final url,name;
  View(this.url,this.name);
_state createState()=>_state(url,name);
}
class _state extends State<View>
{

  double progress =0 ;
  ReceivePort _port = ReceivePort();
static downloadingCallback(id,status,progress){
 SendPort _sendport = IsolateNameServer.lookupPortByName("downloading");
 _sendport.send([id,status,progress]);
}

  @override
  void initState()
  {
   // main();
    super.initState();
    
    
    IsolateNameServer.registerPortWithName(_port.sendPort, "downloading"); 
    _port.listen((message) {
      setState(() async{
        progress = message[2];
        await FlutterDownloader.initialize(debug: true);
      });
    });
    
    FlutterDownloader.registerCallback((downloadingCallback));
  }
  bool isLoading = false;
  final url,name;
  _state(this.url,this.name);
  Widget build(BuildContext context)
  {
    return isLoading?
    Center(child: CircularProgressIndicator(),)
    :Scaffold(
        appBar: AppBar(actions: [
          IconButton(icon:Icon(Icons.download_rounded),onPressed: () async{
            try {
              setState(() {
                isLoading=true;
                
              });
              // Saved with this method.
  var  dir =await getExternalStorageDirectory();

  var id = await FlutterDownloader.enqueue(url:url,savedDir: dir.path,fileName:name ,showNotification: true,openFileFromNotification: false);
              setState(() {
                isLoading=false;
              });
              await FlutterDownloader.open(taskId: id);
              if ( id != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Downloaded"),));
                return ;
              }
              else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permission not granted"),));
                return;
              }
            } on Error catch (error) {
              setState(() {
                isLoading=false;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error in downloading"+error.toString())));
              print(error);
            }
          },),
        ],
        ),
                body: Container(
          margin: EdgeInsets.all(3),
          width: double.infinity,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(border: Border.all(color:Colors.black)),
          child: Column(children:[
            Text(name),
            SizedBox(height:10),           
            ])
          )
        );
  }
}

