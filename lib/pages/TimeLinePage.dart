import 'package:flutter/material.dart';

import '../widgets/HeaderPage.dart';
import '../widgets/ProgressWidget.dart';
import '../widgets/ProgressWidget.dart';

class TimeLinePage extends StatefulWidget {
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context,isAppTitile: true) ,
      body: circularProgress(),
    );
  }
}
