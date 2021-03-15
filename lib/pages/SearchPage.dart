

import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/ProfilePage.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final userReference= Firestore.instance.collection("users");
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  TextEditingController searchtextController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;
  controlSearch(String str){
   Future<QuerySnapshot> allUsers = userReference.where("profileName", isGreaterThanOrEqualTo: str).getDocuments();
    setState(() {
      futureSearchResults = allUsers;
//      print(futureSearchResults);
    });
  }
  AppBar searchPageAppBar(){

    emptySearchText(){
      searchtextController.clear();
    }
    return AppBar(
      backgroundColor: Colors.black,
      title: TextFormField(
        style: TextStyle(
          color: Colors.white,
        ),
  controller: searchtextController,
        decoration: InputDecoration(
          hintText: "Search..",
          hintStyle: TextStyle(
            color: Colors.grey
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
           filled: true,
          prefixIcon: Icon(Icons.person, color: Colors.white, size: 30.0 ,),
            suffixIcon: IconButton(icon: Icon(Icons.clear,color: Colors.white,),onPressed:(){
              emptySearchText();
      })
        ),
        onChanged: searchtextController.value.toString().length==0? noResult:controlSearch,
        onFieldSubmitted: controlSearch,
      ),
    );
  }
  Container noResult(){
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(Icons.group,color: Colors.grey,size: 100.0 ,),
            Text(
              "Search Users",
              textAlign: TextAlign.center,
               style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
  displayUsersFound(){
    return FutureBuilder(
      future: futureSearchResults ,
      builder: (context,dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress();
        }
        else {
          List<UserResult> searchUserResult = [];
          dataSnapshot.data.documents.forEach((document){
            User user = User.fromDocument(document);
            UserResult userResult = UserResult(user: user,);
            searchUserResult.add(userResult);
            print(user.username);
          });
        return searchUserResult.length>0 ? ListView(
          children: searchUserResult,
        ): Container(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Icon(Icons.error,color: Colors.grey,size: 100.0 ,),
                  Text(
                    "No User Found !",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),
                  )
                ],
              ),
            ),
          );;
        }
        }
    );
      }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: searchPageAppBar(),
      body: futureSearchResults==null?noResult():displayUsersFound(),
    );
  }
}

class UserResult extends StatelessWidget {
  User user;
  UserResult({this.user});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(4.0),
     child: Container(
       color: Colors.white54,
       child: Column(
         children: [
           GestureDetector(
             onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(user: user,)));
             },
             child: ListTile(
               leading: CircleAvatar(backgroundColor: Colors.black, backgroundImage: CachedNetworkImageProvider(user.url),),
               title: Text(
                 user.profileName,
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 16.0,
                   fontWeight: FontWeight.bold,

                 ),
               ),
               subtitle: Text(
                 user.username,
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 13.0,
                   fontWeight: FontWeight.bold,

                 ),
               ),
             ),
           )
         ],
       ),
     ),
    );
  }
}
