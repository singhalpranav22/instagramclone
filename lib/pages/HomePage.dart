import 'package:buddiesgram/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'CreateAccountPage.dart';
import 'NotificationsPage.dart';
import 'ProfilePage.dart';
import 'SearchPage.dart';
import 'TimeLinePage.dart';
import 'UploadPage.dart';


final GoogleSignIn gSignIn = GoogleSignIn();
final userReference= Firestore.instance.collection("users");
final DateTime timestamp = DateTime.now();
User currentUser;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSigned = false;
  PageController pageController;
  int getPageIndex =0;
  controlSignIn(GoogleSignInAccount googleSignInAccount) async{

    if(googleSignInAccount!=null){
      await saveUserInfoToFireStore();
      setState(() {
        print(googleSignInAccount.displayName);
        isSigned=true;
      });
    }
    else{
      setState(() {
        isSigned=false;
      });
    }
  }
  saveUserInfoToFireStore() async{
     final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
     DocumentSnapshot documentSnapshot = await userReference.document(gCurrentUser.id).get();
     if(!documentSnapshot.exists){
       final username = await Navigator.push(context,MaterialPageRoute(builder: (context) => CreateAccountPage()));
       userReference.document(gCurrentUser.id).setData({
         "id" :  gCurrentUser.id,
         "profileName" : gCurrentUser.displayName,
         "username" : username,
         "url" : gCurrentUser.photoUrl,
         "email" : gCurrentUser.email,
         "bio" : "",
         "timestamp" : timestamp
       });
       documentSnapshot = await userReference.document(gCurrentUser.id).get();
     }
    currentUser = User.fromDocument(documentSnapshot);

  }
  loginUser(){
    gSignIn.signIn();
  }
  logoutUser(){
    gSignIn.signOut();
  }
  whenPageChange(int pageIndex){
    setState(() {
      this.getPageIndex=pageIndex;
    });

  }
  changePage(int pageIndex){
    pageController.animateToPage(pageIndex, duration: Duration(microseconds: 300), curve: Curves.bounceInOut);
  }
  Scaffold buldHomeScreen(){
    return Scaffold(
      body: PageView(
        children: [
//          TimeLinePage(),
        RaisedButton(onPressed: (){
          logoutUser();
        },
        child: Text("Sign out !"),),
          SearchPage(),
          UploadPage(),
          NotificationsPage(),
          ProfilePage(),
        ],
        controller: pageController,
        onPageChanged: whenPageChange,
        physics: NeverScrollableScrollPhysics(),

      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: changePage,
        activeColor: Colors.white,
        inactiveColor: Colors.blueGrey,
        backgroundColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }
  Scaffold buildSignInScreen(){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Theme.of(context).accentColor,Theme.of(context).primaryColor]
          )
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Instagram",style: TextStyle(
              fontSize: 92.0,
              color: Colors.white,
              fontFamily: "Signatra"
            ),

            ),
            GestureDetector(
              onTap: (){
                print("Button Pressed");
                loginUser();
              },
              child: Container(
                width: 270.0,
                height: 65.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/google_signin_button.png"),
                    fit: BoxFit.cover,
                  )
                ),
              ),

            )
          ],
        ),
      ),
    );
  }
  void dispose(){
    pageController.dispose();
    super.dispose();
}
  @override
  void initState() {
    // TODO: implement initState
    pageController=PageController();
    gSignIn.onCurrentUserChanged.listen((gSigninAccount) {
      controlSignIn(gSigninAccount);
    },onError: (error){
      print("Error Occured : " + error.toString());
    });
    gSignIn.signInSilently(suppressErrors: false).then((gSigninAccount){
      controlSignIn(gSigninAccount);
    }).onError((error, stackTrace) {
      print("Error : "+error);
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isSigned){
  return buldHomeScreen();
    }
    else{
      return buildSignInScreen();
    }
  }
}
