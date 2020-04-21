import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'file:///D:/video_chatting_app/lib/Screens/ChatScreen/ChatPage.dart';
import 'package:video_chatting_app/models/contact.dart';
import 'package:video_chatting_app/models/user.dart';
import 'package:video_chatting_app/provider/user_provider.dart';
import 'package:video_chatting_app/resources/auth_methods.dart';
import 'package:video_chatting_app/resources/chat_methods.dart';
import 'package:video_chatting_app/widgets/cached_image.dart';
import 'package:video_chatting_app/widgets/custom_tile.dart';
import 'file:///D:/video_chatting_app/lib/Screens/ChatScreen/widgets/lastMessageContainer.dart';
import 'file:///D:/video_chatting_app/lib/Screens/ChatScreen/widgets/state_indicator.dart';

class ChatsView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ChatsView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;
          return ViewLayout(
            contact: user,
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
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
        child: CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPage(
                    receiver: contact,
                  ))),
      title: Text(
        contact?.name ?? "..",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19.0),
      ),
      subtitle: LastMessageContainer(
          stream: _chatMethods.fetchLastMessageBetween(
              senderId: userProvider.getUser.uid, receiverId: contact.uid)),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60.0, maxWidth: 60.0),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80.0,
              isRound: true,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: OnlineDotIndicator(
                uid: contact.uid,
              ),
            )
          ],
        ),
      ),
    ));
  }
}.23
    69+*/
9+6
3..
    36+9*-*