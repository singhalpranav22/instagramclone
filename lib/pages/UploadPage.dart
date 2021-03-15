import 'dart:io';

import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/HeaderPage.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Imd;


class UploadPage extends StatefulWidget {
  final User user;
  final StorageReference storageReference;
  UploadPage({this.user,this.storageReference});
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>{
  File file;
  bool isUploading = false;
  String postId = Uuid().v4();
  TextEditingController descController = TextEditingController();
  TextEditingController locController = TextEditingController();
  captureImagewithCam () async {
    Navigator.pop(context);
   File imgFile = await ImagePicker.pickImage(
     source: ImageSource.camera,
     maxHeight: 680,
     maxWidth: 970
   );
   setState(() {
     this.file= imgFile;
   });
  }
  pickImagefromGallery () async {
    Navigator.pop(context);
    File imgFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 680,
        maxWidth: 970
    );
    setState(() {
      this.file= imgFile;
    });
  }
  takeImage(Context){
    return showDialog(
        context: Context,
        builder: (Context){
          return SimpleDialog(

            title: Text("New Post",style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,

            ),),
            children: [
              SimpleDialogOption(
                child: Text("Capture Image With Camera",style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),),
                onPressed: (){
                  captureImagewithCam();
                },
              ),
              SimpleDialogOption(
                child: Text("Select Image from Gallery",style: TextStyle(
                    color: Colors.white,
                   fontSize: 18.0,
                ),),
                onPressed: (){
                  pickImagefromGallery();
                },
              ),
              SimpleDialogOption(
                child: Text("Cancel",style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white
                ),),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
  displayUploadScreen(){
    return Scaffold(
      appBar: header(context,title: "Upload"),
      body: Center(
        child: Container(
          color: Theme.of(context).accentColor.withOpacity(0.4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo,color: Colors.grey,size: 120,),
              Padding(
                padding: const EdgeInsets.only(top :15.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(9.0)),
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Upload Image",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.white,
                    ),),
                  ),
                  onPressed: (){
                    takeImage(context);
                  },

                ),
              )
            ],
          ),

        ),
      ),
    );
  }

  getUserCurrentLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark first = placemarks[0];
    String completeAddress = '${first.subThoroughfare} ${first.thoroughfare}, ${first.subLocality} ${first.locality}, ${first.subAdministrativeArea} ${first.administrativeArea}, ${first.postalCode} ${first.country}';
    String specificLoc = '${first.locality}, ${first.country}';
    setState(() {
      locController.text = specificLoc;
    });


  }
  compressPhoto() async{
    final tDir = await getTemporaryDirectory();
    final path = tDir.path;
    Imd.Image tImgFile = Imd.decodeImage(file.readAsBytesSync());
    final compImage = File('$path/img_$postId.jpg')..writeAsBytesSync(Imd.encodeJpg(tImgFile,quality: 90));
    setState(() {
      file = compImage;
    });

  }

  savePostInfotoFirestore({String downloadUrl,String desc,String loc})
  {
    postReference.document(widget.user.id).collection("userPosts").document(postId).setData({
      "postId" : postId,
      "ownerId" : widget.user.id,
      "timestamp" : timestamp,
      "likes" :  {},
      "username" : widget.user.username,
      "description" : desc,
      "location" : loc,
      "url" : downloadUrl,
    });

    setState(() {
      descController.clear();
      locController.clear();
      isUploading=false;
      file=null;
      postId = Uuid().v4();
    });
  }
  Future<String> uploadPic(mImgfile) async{
      StorageUploadTask storageUploadTask = widget.storageReference.child("post_$postId.jpg").putFile(mImgfile);
      StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      return downloadUrl;
  }
  controlUploadandsave() async{
     setState(() {
       isUploading=true;
     });
     await compressPhoto();

     String downloadUrl = await uploadPic(file);
     savePostInfotoFirestore(downloadUrl: downloadUrl,desc: descController.text,loc: locController.text);
  }

  removePostInfo(){
    setState(() {
      locController.clear();
      descController.clear();
      file=null;
    });
  }
  displayUploadForm(){
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).accentColor,
      leading: IconButton(icon: Icon(Icons.arrow_back ,color: Colors.white,), onPressed: removePostInfo),
      title: Text("New Post", style: TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),),
      actions: [
        FlatButton(
    onPressed: isUploading? null : (){
       controlUploadandsave();
  },
            child: Text("Share",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold , fontSize: 16.0),))
      ],
    ),
    body: ListView(
       children: [
         isUploading == true ? linearProgress() : Text(""),
         Container(
           height: 230.0,
           width: MediaQuery.of(context).size.width * 0.8,
           child: Center(
             child: AspectRatio(
               aspectRatio: 16/9,
               child: Container(
                 decoration: BoxDecoration(
                   image: DecorationImage(
                     image:  FileImage(file) , fit: BoxFit.cover,
                   )
                 ),
               ),
             ),
           ),
         ),
         ListTile(
           leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(widget.user.url)
         ),
           title: Container(
             width : 250.0,
             child: TextField(
                style: TextStyle(color: Colors.white),
               controller: descController,
                decoration: InputDecoration(
                  hintText: "Say Something about Image...",
                    hintStyle: TextStyle(color: Colors.white),
                   border: InputBorder.none,

                ),
             ),
           ),
         ),
         Divider(),
         ListTile(
           leading: Icon(
             Icons.location_city , color: Colors.white, size: 36.0,
           ),
           title: Container(
             width : 250.0,
             child: TextField(
               style: TextStyle(color: Colors.white),
               controller: locController,
               decoration: InputDecoration(
                 hintText: "Write Image Location Here...",
                 hintStyle: TextStyle(color: Colors.white),
                 border: InputBorder.none,

               ),
             ),
           ),
         ),
         Container(
            width: 220.0,
           height: 110.0,
           alignment: Alignment.center,
           child: RaisedButton.icon(
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(35.0)  ,

             ),
             color: Colors.blue,
             icon: Icon(
               Icons.location_on,
               color: Colors.white,
             ),
             label: Text("Get My Current Location" ,style: TextStyle(
               color: Colors.white
             ),),
             onPressed: (){
               getUserCurrentLocation();
             },
           ),
         )

       ],
    ),
  );
  }
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return file==null?displayUploadScreen():displayUploadForm();
  }
}
