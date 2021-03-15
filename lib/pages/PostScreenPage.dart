import 'package:buddiesgram/widgets/HeaderPage.dart';
import 'package:buddiesgram/widgets/PostWidget.dart';
import 'package:flutter/material.dart';

class PostScreenPage extends StatelessWidget {
  final Post post;
  PostScreenPage({this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,title: post.username ),
      body: ListView(
        children: [
          post,
        ],
      ),
    );
  }
}
