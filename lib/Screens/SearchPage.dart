import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chatting_app/Screens/ChatPage.dart';
import 'package:video_chatting_app/models/user.dart';
import 'package:video_chatting_app/resources/firebase_repository.dart';
import 'package:video_chatting_app/widgets/custom_tile.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FirebaseRepository _repository = FirebaseRepository();
  List<User> userList;
  String query ="";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _repository.getCurrentUser().then((FirebaseUser user){
      _repository.fetchAllUsers(user).then((List<User> list){
       setState(() {
         userList=list;
       });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
          color: Colors.white,),
          onPressed: ()=> Navigator.pop(context),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 20),
          child: Padding(
            padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val){
              setState(() {
                query= val;
              });

            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close,
                color: Colors.white,),
                onPressed: (){
                  searchController.clear();
                },
              ),
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.white
              )
            ),
          ),
          ),

        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade500]
            ),
          ),
        ),

      ),
      body:  Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: buildSuggestions(query),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<User> suggestionsList = query.isEmpty
        ? []
        : userList.where((User user){
          String _getUsername = user.username.toLowerCase();
          String _query = query.toLowerCase();
          String _getName = user.name.toLowerCase();
          bool matchedUsername = _getUsername.contains(_query);
          bool matchedName = _getName.contains(_query);

          return (matchedUsername || matchedName);
    }).toList();
//        userList.where((User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
//            (user.name.toLowerCase().contains(query.toLowerCase())))
//

    return ListView.builder(itemCount: suggestionsList.length,
      itemBuilder: ((context, index){
        User searchedUser = User(
          uid: suggestionsList[index].uid,
          profilePhoto:suggestionsList[index].profilePhoto,
          name  : suggestionsList[index].name,
          username:  suggestionsList[index].username

        );
        return CustomTile(
          mini: false,
          onTap: (){
            Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiver: searchedUser,
              )
            ));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.username,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          subtitle: Text(
            searchedUser.name,
            style: TextStyle(
              color: Colors.white
            ),
          ),
        );
      }),
    );
  }
}
