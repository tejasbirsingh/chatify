import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'file:///D:/video_chatting_app/lib/Screens/ChatScreen/ChatPage.dart';
import 'package:video_chatting_app/models/contact.dart';
import 'package:video_chatting_app/models/friend.dart';
import 'package:video_chatting_app/models/user.dart';
import 'package:video_chatting_app/provider/user_provider.dart';
import 'package:video_chatting_app/resources/auth_methods.dart';
import 'package:video_chatting_app/resources/chat_methods.dart';
import 'package:video_chatting_app/widgets/cached_image.dart';
import 'package:video_chatting_app/widgets/custom_tile.dart';
import 'file:///D:/video_chatting_app/lib/Screens/ChatScreen/widgets/lastMessageContainer.dart';
import 'file:///D:/video_chatting_app/lib/Screens/ChatScreen/widgets/state_indicator.dart';

class friendView extends StatelessWidget {
  final Friend friend;
  final AuthMethods _authMethods = AuthMethods();

  friendView(this.friend);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(friend.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;
          return ViewLayout(
            friend: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User friend;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.friend,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
        child: CustomTile(

          mini: false,
          onTap: () =>
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatPage(
                            receiver: friend,
                          ))),
          title: Text(
            friend?.name ?? "..",
            style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19.0),
          ),
          subtitle: Text(""),
//          subtitle: LastMessageContainer(
//              stream: _chatMethods.fetchLastMessageBetween(
//                  senderId: userProvider.getUser.uid, receiverId: friend.uid)),
          leading: Container(
            constraints: BoxConstraints(maxHeight: 60.0, maxWidth: 60.0),
            child: Stack(
              children: <Widget>[
                CachedImage(
                  friend.profilePhoto,
                  radius: 80.0,
                  isRound: true,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: OnlineDotIndicator(
                    uid: friend.uid,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}