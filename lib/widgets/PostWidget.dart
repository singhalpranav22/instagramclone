import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/pages/ProfilePage.dart';
import 'package:buddiesgram/widgets/CImageWidget.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {


  final String postId;
  final String ownerId;
  final String timeStamp;
  final dynamic likes;
  final String username;
  final String description;
  final String location;
  final String url;

  Post({
   this.username,this.url,this.postId,this.description,this.likes,this.location,this.ownerId,this.timeStamp
});

  factory Post.fromDocument(DocumentSnapshot documentSnapshot){
    return Post(
      postId: documentSnapshot["postId"],
      username: documentSnapshot["username"],
      timeStamp: documentSnapshot["timeStamp"],
      url: documentSnapshot["url"],
      description: documentSnapshot["description"],
      likes: documentSnapshot["likes"],
      location: documentSnapshot["location"],
      ownerId: documentSnapshot["ownerId"],
    );
  }

  int getnumLikes(likes){
    if(likes==null) return 0;
    int count=0;
    likes.values.forEach((eachValue){
      if(eachValue==true){
         count++;
      }
    });
    return count;
  }
  @override
  _PostState createState() => _PostState(
   postId: this.postId,
  ownerId:this.ownerId,
   timeStamp: this.timeStamp,
   likes: this.likes,
  username: this.username,
  description: this.description,
 location: this.location,
   url: this.url,
    likeCount : this.getnumLikes(likes),

  );
}

class _PostState extends State<Post> {

  final String postId;
  final String ownerId;
  final String timeStamp;
  final dynamic likes;
  final String username;
  final String description;
  final String location;
  final String url;
  int likeCount;
  bool isLiked;
  bool showHeart = false;
   final String currentUserId = currentUser.id;

  _PostState({
    this.username,this.url,this.postId,this.description,this.likes,this.location,this.ownerId,this.timeStamp,this.likeCount
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          createPostHead(),
          createPostPic(),
          createPostFooter(),
        ],
      ),
    );
  }

  createPostHead(){
    return FutureBuilder(
        future: userReference.document(ownerId).get(),
        builder:(context,dataSnapshot){
            if(!dataSnapshot.hasData){
              return circularProgress();
    }
            User user = User.fromDocument(dataSnapshot.data);
            bool isOwner = currentUserId == ownerId;
            return ListTile(
        leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(user.url),backgroundColor: Colors.grey,),
              title: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(user: user,)));
                },
                child: Text(
                  user.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              subtitle: Text(location , style: TextStyle(color: Colors.white),),
              trailing: isOwner ? IconButton(
                icon: Icon(Icons.delete ,color: Colors.white,),
                onPressed: (){
                  print('Delete Tapped!');
              },
              ) : Text(""),

            );
    }
    );
  }

  createPostPic(){
    return GestureDetector(
      onDoubleTap: (){
        print("Like Tapped!");
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(url),

        ],
      ),
    );
  }

  createPostFooter(){
    return Column(

      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.start,
          children: [
             Padding(
               padding: const EdgeInsets.only(top:10.0, left: 20.0),
               child: GestureDetector(
                onTap: (){
                  print("Like");
                },
                 child:
                   Icon(
                     Icons.favorite_border,
                     size: 28.0,
                       color: Colors.pink,
                   ),
//                 Icon(
//                   isLiked ? Icons.favorite : Icons.favorite_border,
//                   size: 28.0,
//                   color: Colors.pink,
//                 ),
               ),
             ),
            Padding(
              padding: const EdgeInsets.only(top:12.0,left:20.0,right: 20.0),
              child: GestureDetector(
                onTap: (){
                  print("Comment");
                },
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                '$likeCount likes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  '$username : ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Expanded(child: Text('$description',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400
                ),
              ))
            ],

          ),
        )
      ],
    );
  }
}
