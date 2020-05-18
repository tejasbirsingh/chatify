import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chatting_app/Screens/ChatScreen/widgets/quietBox.dart';
import 'package:video_chatting_app/models/friend.dart';
import 'package:video_chatting_app/provider/user_provider.dart';
import 'package:video_chatting_app/resources/chat_methods.dart';

import 'file:///E:/IdeaProjects/video_chatting_app/lib/Screens/ContactsScreen/friend_user.dart';

class contactsPage extends StatefulWidget {
  @override
  _contactsPageState createState() => _contactsPageState();
}

class _contactsPageState extends State<contactsPage> {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            color:Theme.of(context).accentColor,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2 - 325.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0))),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _chatMethods.fetchFriends(userId: userProvider.getUser.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var docList = snapshot.data.documents;
                    if (docList.isEmpty) {
                      return QuietBox();
                    }
                    return ListView.builder(
                      itemCount: docList.length,
                      itemBuilder: ((context, index) {
                        Friend friend = Friend.fromMap(docList[index].data);
                        return friendView(friend);
                      }),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
