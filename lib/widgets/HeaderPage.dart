import 'package:flutter/material.dart';

AppBar header(context , {bool isAppTitile=false,String title, disableBackButton=false}){
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    automaticallyImplyLeading: disableBackButton?false:true,
    title:  Text(
       isAppTitile ? "Instagram": title,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitile?"Signatra":"" ,
        fontSize: isAppTitile?45.0:22.0,
      ),
      overflow: TextOverflow.ellipsis,

    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}