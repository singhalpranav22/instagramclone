import 'package:buddiesgram/pages/PostScreenPage.dart';
import 'package:buddiesgram/widgets/PostWidget.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  final Post post;
  PostTile({this.post});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => PostScreenPage(post: post,)));
      },
      child: Image.network(post.url),
    );
  }
}
