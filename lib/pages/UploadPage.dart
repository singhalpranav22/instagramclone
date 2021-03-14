import 'dart:io';

import 'package:buddiesgram/widgets/HeaderPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File file;
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
  @override
  Widget build(BuildContext context) {
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
}
