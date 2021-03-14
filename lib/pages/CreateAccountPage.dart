import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/HeaderPage.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();

  String username="";

  submitUserName(){
  final form = _formkey.currentState;
  if(form.validate()){
     form.save();
     SnackBar snackBar= SnackBar(content: Text("Welcome "+username));
     _scaffoldkey.currentState.showSnackBar(snackBar);
     Timer(
       Duration(seconds: 4),(){
       Navigator.pop(context,username);
     }
     );

  }
  }
  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: header(context,title: "Settings"),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 26.0),
                  child: Center(
                    child: Text("Welcome!",style: TextStyle(
                      fontSize: 26.0,
                      color: Colors.white,
                    ),),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 26.0),
                  child: Center(
                    child: Text("Set up a Username",style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Container(
                    child: Form(
                      key: _formkey,
                      autovalidate: true,
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        validator: (val){
                          if(val.trim().length<5 || val.isEmpty){
                            return "Username is very short";
                          }
                          else if(val.trim().length>15){
                            return "Username is very long";
                          }
                          else{
                            return null;
                          }
                        },
                        onSaved: (val) => username = val,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide:  BorderSide(color: Colors.grey),
                          ),
                          focusedBorder:UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                          ),
                          border: OutlineInputBorder(),
                          labelText: "Username",
                          labelStyle:  TextStyle(fontSize: 16.0),
                          hintText: "Must be at least 5 characters",
                          hintStyle: TextStyle(color: Colors.grey)
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    submitUserName();
                  },
                  child: Container(
                    height: 55.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                         "Proceed ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
