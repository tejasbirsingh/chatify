import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chatting_app/Screens/ChatScreen/widgets/userDetailsContainer.dart';
import 'package:video_chatting_app/Screens/settingsPage.dart';
import 'package:video_chatting_app/models/contact.dart';
import 'package:video_chatting_app/provider/user_provider.dart';
import 'package:video_chatting_app/resources/chat_methods.dart';
import 'package:video_chatting_app/widgets/appBar.dart';

import 'file:///D:/video_chatting_app/lib/Screens/ChatScreen/widgets/chat_users.dart';
import 'file:///D:/video_chatting_app/lib/Screens/ChatScreen/widgets/new_chat_button.dart';
import 'file:///D:/video_chatting_app/lib/Screens/ChatScreen/widgets/quietBox.dart';
import 'file:///D:/video_chatting_app/lib/Screens/ChatScreen/widgets/user_circle.dart';

class ChatListScreen extends StatelessWidget {
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      color: Theme.of(context).accentColor,
      title: GestureDetector(
          onTap: () => showModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).backgroundColor,
            builder: (context) => UserDetailsContainer(),
            isScrollControlled: true,
          ),
          child: UserCircle()),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(context, "/search_page");
          },
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => settingsPage())),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Stack(
      children: [
        Container(color: Theme.of(context).accentColor),
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 2 - 325.0),
          child: Container(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0))),
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatMethods.fetchContacts(
                    userId: userProvider.getUser.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var docList = snapshot.data.documents;
                    if (docList.isEmpty) {
                      return QuietBox();
                    }
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: docList.length,
                      itemBuilder: ((context, index) {
                        Contact contact = Contact.fromMap(docList[index].data);
                        return ChatsView(contact);
                      }),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )),
        ),
      ],
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
