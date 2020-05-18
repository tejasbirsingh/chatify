import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chatting_app/models/user.dart';
import 'package:video_chatting_app/provider/user_provider.dart';
import 'package:video_chatting_app/resources/auth_methods.dart';
import 'package:video_chatting_app/resources/chat_methods.dart';
import 'package:video_chatting_app/widgets/custom_tile.dart';

import 'file:///D:/video_chatting_app/lib/Screens/ChatScreen/ChatPage.dart';

import 'ChatScreen/widgets/state_indicator.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final AuthMethods _authMethods = AuthMethods();
  final ChatMethods _chatMethods = ChatMethods();

  List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _authMethods.getCurrentUser().then((FirebaseUser user) {
      _authMethods.fetchAllUsers(user).then((List<User> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
//      backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 20),
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: TextField(
                controller: searchController,
                onChanged: (val) {
                  setState(() {
                    query = val;
                  });
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        searchController.clear();
                      },
                    ),
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.white)),
              ),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: buildSuggestions(query, userProvider.getUser),
        ),
      ),
    );
  }

  buildSuggestions(String query, uid) {
    final List<User> suggestionsList = query.isEmpty
        ? []
        : userList.where((User user) {
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

    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) {
        User searchedUser = User(
            uid: suggestionsList[index].uid,
            profilePhoto: suggestionsList[index].profilePhoto,
            name: suggestionsList[index].name,
            username: suggestionsList[index].username,
            state: suggestionsList[index].state);
        var v = searchedUser.state == null ? 3 : searchedUser.state;

        return CustomTile(
          mini: false,
          isRequest: true,
          requestButtonPress: () {
            _chatMethods.sendRequest(
                currentUser: uid,
                requestReceiver: searchedUser != null ? searchedUser : "");
          },
          onLongPress: () {
            _chatMethods.removeFriend(
                user: uid, friend: searchedUser != null ? searchedUser : "");
          },
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          receiver: searchedUser,
                        )));
          },
          leading: Container(
            constraints: BoxConstraints(maxHeight: 60.0, maxWidth: 60.0),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 80,
                  width: 80.0,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(searchedUser.profilePhoto),
                    backgroundColor: Colors.grey,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: OnlineDotIndicator(
                    uid: searchedUser.uid,
                  ),
                )
              ],
            ),
          ),
          title: Text(
            searchedUser.name,
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          subtitle: Text(
            searchedUser.username,
            style: TextStyle(color: Colors.white),
          ),
        );
      }),
    );
  }

  Color statusColor(state) {
    Color c;
    switch (state) {
      case 1:
        {
          c = Colors.green;
        }
        break;

      case 2:
        {
          c = Colors.orange;
        }
        break;
      case 3:
        {
          c = Colors.red;
        }
        break;
    }
    return c;
  }
}
