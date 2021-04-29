import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';


class Upload {
var _imagepath;
File _image;
final picker = ImagePicker();
List id=[];
var p="";
final currentId = FirebaseAuth.instance.currentUser.uid;



Future getFile(BuildContext context,value,oppId)async
{
  id.add(oppId);
id.add(currentId);
id.sort((a,b) => a.compareTo(b));
p+=id[0];
p+=id[1];
  FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true);

if(result != null) {
  List<PlatformFile> files = result.files;
    files.forEach((element) async{
      p+=basename(element.path);
      p+="."+element.extension.toString();
var uploadTask = FirebaseStorage.instance.ref().child(p).putFile(File(element.path));
await uploadTask.whenComplete((){
  print("uploaded");
});
var ref = FirebaseStorage.instance.ref().child(p);
var path = await ref.getDownloadURL();
print("path "+path);
await FirebaseDatabase.instance.reference().child("messages").push().set(
  {
    "fromId":currentId,
    "toId":oppId,
    "time":DateTime.now().millisecondsSinceEpoch,
    "msg":basename(element.path).toString(),
    "ImagePath":path
  }
);
});
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("sent"),));
} 
else {
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("cancelled"),));
   return;
}

}




Future getimage(BuildContext context,value,oppId)async{
id.add(oppId);
id.add(currentId);
id.sort((a,b) => a.compareTo(b));
p+=id[0];
p+=id[1];
  if(value == "Gallery")
  {
  var image = await picker.getImage(source: ImageSource.gallery);
  if(image==null)
  {
    return;
  }
  _image =File(image.path);
   _imagepath = (basename(image.path));
   p+=_imagepath.toString();

  }
else if(value == "Camera")
{
    var image = await picker.getImage(source: ImageSource.camera);
    if(image==null)
    {
      return;
    }
  _image =File(image.path);
   _imagepath = (basename(image.path));
   p+=_imagepath.toString();
}
else if(value == "Vedio")
{
    var image = await picker.getVideo(source: ImageSource.gallery);
    if(image==null)
    {
      return;
    }
  _image =File(image.path);
   _imagepath = (basename(image.path));
   p+=_imagepath.toString();
}





var uploadTask = FirebaseStorage.instance.ref().child(p).putFile(_image);
await uploadTask.whenComplete((){
  print("uploaded");
});
var ref = FirebaseStorage.instance.ref().child(p);
var path = await ref.getDownloadURL();
print("path "+path);
await FirebaseDatabase.instance.reference().child("messages").push().set(
  {
    "fromId":currentId,
    "toId":oppId,
    "time":DateTime.now().millisecondsSinceEpoch,
    "msg":_imagepath.toString(),
    "ImagePath":path
  }
);
 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("sent"),));
}


}