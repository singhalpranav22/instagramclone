import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/EditProfilePage.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/PostTileWidget.dart';
import 'package:buddiesgram/widgets/PostWidget.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/HeaderPage.dart';

class ProfilePage extends StatefulWidget {

  User user;
  ProfilePage({this.user});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int numPosts=0;
  createButtonTitileandFunction({String title,Function performFunction}){
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Container(
        child: FlatButton(
          onPressed: performFunction,
          child: Container(
            width: 190.0,
            height: 26.0,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),

          ),
        ),
      ),
    );
  }
 final String currentOnlineUserid = currentUser.id;
  bool isOwnProfile=false;
  createButton(){
    isOwnProfile = currentOnlineUserid==widget.user.id;
    if(isOwnProfile==true){
      return createButtonTitileandFunction(title : "Edit Profile" , performFunction : editUserProfile);
    }
    else
       return Container();
  }
  editUserProfile(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(user: widget.user,)));
    setState(() {

    });
  }
  createColumns(String title,int count){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(count.toString() ,style: TextStyle(
          fontSize:  20.0,
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text(
            title,style: TextStyle(
              fontSize:  16.0,
              color: Colors.grey,
              fontWeight: FontWeight.w600
          ),
          ),
        )
      ],
    );
  }
  createProfileTopView(){
    return FutureBuilder(
        future: userReference.document(widget.user.id).get(),
        builder: (context,dataSnapshot){
      if(!dataSnapshot.hasData) return circularProgress();
       User user = User.fromDocument(dataSnapshot.data);
       return Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
           children: [
             Row(
               children: [
                 CircleAvatar(backgroundImage: CachedNetworkImageProvider(user.url),radius: 45.0,backgroundColor: Colors.grey,),
                 Expanded(
                   flex: 1,
                   child: Column(
                     children: [
                       Row(
                         mainAxisSize: MainAxisSize.max,
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           createColumns("Posts",numPosts),
                           createColumns("Followers",0),
                           createColumns("Following",0),
                         ],

                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           createButton(),
                         ],
                       )
                     ],
                   ),
                 )
               ],
             ),
             Container(
               alignment: Alignment.centerLeft,
               padding: EdgeInsets.only(top: 8.0),
               child: Text(
                 user.username,
                 style: TextStyle(
                   fontSize: 14.0,
                   color: Colors.white,
                 ),
               ),
             ),
             Container(
               alignment: Alignment.centerLeft,
               padding: EdgeInsets.only(top: 4.0),
               child: Text(
                 user.profileName,
                 style: TextStyle(
                   fontSize: 18.0,
                   color: Colors.white,
                 ),
               ),
             ),
             Container(
               alignment: Alignment.centerLeft,
               padding: EdgeInsets.only(top: 3.0),
               child: Text(
                 user.bio,
                 style: TextStyle(
                   fontSize: 18.0,
                   color: Colors.white54,
                 ),
               ),
             ),

           ],
         ),
       );
    }
    );
  }

  bool loading =false;
  int countPosts=0;
  List<Post> posts = [];
  displayProfilePost(){
    if(loading) return circularProgress();
    if(posts.length==0) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Icon(
                Icons.photo_library, color: Colors.white, size: 200.0,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "No Posts to Show",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            )

          ],
        ),
      );
    }
    else if(postOrientation=="grid"){
    List<GridTile> gridTiles = [];
//    posts.forEach((element) {
//      gridTiles.add(GridTile(child:  PostTile()));
//    });
    for(int i=0;i<posts.length;i++){
      gridTiles.add(GridTile(child: PostTile(post: posts[i],)));
    }
    return GridView.count(crossAxisCount: 3,
    childAspectRatio: 1.0,
      mainAxisSpacing: 1.5,
      crossAxisSpacing: 1.5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: gridTiles,
    );
    }
    else if(postOrientation=="list"){
      return Column(
        children: posts,
      );
    }


    }


  getAllProfilePosts() async{
    setState(() {
      loading=true;
    });
    QuerySnapshot querySnapshot = await postReference.document(widget.user.id).collection("userPosts").orderBy("timestamp",descending: true).getDocuments();
    setState(() {
      loading=false;
      countPosts=querySnapshot.documents.length;
      numPosts=querySnapshot.documents.length;
      posts=querySnapshot.documents.map((documentSnapshot) => Post.fromDocument(documentSnapshot)).toList();
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    getAllProfilePosts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,title: "Profile"),
      body: ListView(
        children: [
          createProfileTopView(),
          Divider(),
          createListandGridView(),
          Divider(),
          displayProfilePost(),
        ],
      ),
    );
  }
  String postOrientation = "grid";
  createListandGridView()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(icon: Icon(Icons.grid_on),
        onPressed: (){
          setOrientation("grid");
        },
        color: "grid"==postOrientation? Colors.white:Colors.grey,

        ),
        IconButton(icon: Icon(Icons.list),
          onPressed: (){
            setOrientation("list");
          },
          color: "list"==postOrientation? Colors.white:Colors.grey,

        ),
      ],

    );
  }
  setOrientation(String str){
    setState(() {
      postOrientation=str;
    });
  }
}
