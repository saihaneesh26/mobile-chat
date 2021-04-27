import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
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
              var imageId=await ImageDownloader.downloadImage(url,
                                     destination: AndroidDestinationType.custom(directory: "Chat Images")..inExternalFilesDir()..subDirectory(name),);
              setState(() {
                isLoading=false;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Downloaded"),));
              if (imageId == null) {
                setState(() {
                isLoading=false;
              });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permission not granted"),));
                return;
              }

              // Below is a method of obtaining saved image information.
              // var fileName = await ImageDownloader.findName(imageId);
              // var path = await ImageDownloader.findPath(imageId);
              // var size = await ImageDownloader.findByteSize(imageId);
              // var mimeType = await ImageDownloader.findMimeType(imageId);
            } on PlatformException catch (error) {
              setState(() {
                isLoading=false;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error in downloading"),));
              print(error);
            }
          },),
        ],),
        body: Container(
          margin: EdgeInsets.all(3),
          width: double.infinity,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(border: Border.all(color:Colors.black)),
          child: Image.network(url,scale: 1,),
        ),
      );
  }
}

