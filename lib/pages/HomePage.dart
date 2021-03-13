import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


final GoogleSignIn gSignIn = GoogleSignIn();
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSigned = false;

  controlSignIn(GoogleSignInAccount googleSignInAccount) async{
    if(googleSignInAccount!=null){
      setState(() {
        isSigned=true;
      });
    }
    else{
      setState(() {
        isSigned=false;
      });
    }
  }
  loginUser(){
    gSignIn.signIn();
  }
  logoutUser(){
    gSignIn.signOut();
  }
  Widget buldHomeScreen(){
    return RaisedButton.icon(
      icon: Icon(Icons.close),
      label: Text("Sign Out"),
      onPressed: (){
        logoutUser();
      },

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
  @override
  void initState() {
    // TODO: implement initState
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
