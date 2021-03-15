// To-do
import 'dart:async';

import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/pages/ProfilePage.dart';
import 'package:buddiesgram/widgets/HeaderPage.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class EditProfilePage extends StatefulWidget {
  User user;
  EditProfilePage({this.user});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController profNameEditing = TextEditingController();
  TextEditingController profBioEditing = TextEditingController();
  final _scaffolGlobalKey = GlobalKey<ScaffoldState>();
  bool loading =false;
  bool _profilenameValid = true;
  bool _bioValid=true;

  updateUserData() async{
    setState(() {
      profNameEditing.text.trim().length<3 || profNameEditing.text.isEmpty ? _profilenameValid=false: _profilenameValid=true;
      profBioEditing.text.trim().length>120 ? _bioValid=false : _bioValid=true;
    });
    if(_profilenameValid && _bioValid){
      userReference.document(widget.user.id).updateData({
        "profileName" : profNameEditing.text,
        "bio" : profBioEditing.text,
         
      });
      SnackBar success = SnackBar(content: Text("Profile Updated Successfully!"));
      _scaffolGlobalKey.currentState.showSnackBar(success);
      Timer(
          Duration(seconds: 2),() async{
        DocumentSnapshot documentSnapshot = await userReference.document(widget.user.id).get();
        User tempUser = User.fromDocument(documentSnapshot);
       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()),ModalRoute.withName('/'),);
//      Navigator.pop(context);
      }
      );
    }
  }
  getUserCurrentInfo() async{
    setState(() {
      loading=true;
    });
    DocumentSnapshot documentSnapshot = await userReference.document(widget.user.id).get();
    User tempUser = User.fromDocument(documentSnapshot);
    profNameEditing.text=tempUser.profileName;
    profBioEditing.text=tempUser.bio;
    setState(() {
      loading=false;
    });
  }
  logout() async{
      await gSignIn.signOut();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()),ModalRoute.withName('/'),);
  }
  @override
  void initState() {
    // TODO: implement initState
    getUserCurrentInfo();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolGlobalKey,
       appBar: header(context,title: "Edit Profile"),
        body: loading ? circularProgress() : ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 52.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(widget.user.url),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      children: [
                        editNameForm(),
                        editBioForm(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(onPressed:(){
                      updateUserData();
                    },
                      color: Colors.blue,
                    child: Text("Update",style: TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(onPressed:(){
                      logout();
                    },
                      color: Colors.red,
                      child: Text("Sign Out",style: TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
    );
  }
  editNameForm(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 26.0),
          child: Center(
            child: Text("Edit Name",style: TextStyle(
              fontSize: 22.0,
              color: Colors.white,
            ),),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(
              color: Colors.white,
            ),
            controller: profNameEditing,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide:  BorderSide(color: Colors.grey),
                ),
                focusedBorder:UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                ),
                border: OutlineInputBorder(),
                labelText: "Edit Name",
                labelStyle:  TextStyle(fontSize: 16.0),
                hintText: "Write name here....",
                hintStyle: TextStyle(color: Colors.grey),
              errorText: _profilenameValid?null : "Profile name is too short"
            ),
          ),
        )
      ],
    );
  }

  editBioForm(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 26.0),
          child: Center(
            child: Text("Edit Bio",style: TextStyle(
              fontSize: 22.0,
              color: Colors.white,
            ),),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(
              color: Colors.white,
            ),
            controller: profBioEditing,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide:  BorderSide(color: Colors.grey),
                ),
                focusedBorder:UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                ),
                border: OutlineInputBorder(),
                labelText: "Edit Bio",
                labelStyle:  TextStyle(fontSize: 16.0),
                hintText: "Write Bio here....",
                hintStyle: TextStyle(color: Colors.grey),
                errorText: _bioValid?null : "Bio is too short"
            ),
          ),
        )
      ],
    );
  }
}
