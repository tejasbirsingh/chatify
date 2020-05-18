import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chatting_app/Screens/ChatScreen/widgets/shimmering.dart';
import 'package:video_chatting_app/Screens/Login.dart';
import 'package:video_chatting_app/models/user.dart';
import 'package:video_chatting_app/provider/user_provider.dart';
import 'package:video_chatting_app/resources/auth_methods.dart';
import 'package:video_chatting_app/widgets/appBar.dart';
import 'package:video_chatting_app/widgets/cached_image.dart';

class UserDetailsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    signOut() async {
      final bool isLoggedOut = await AuthMethods().signOut();
      if (isLoggedOut) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          CustomAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Shimmering(),
            actions: <Widget>[
              FlatButton(
                onPressed: () => signOut(),
                child: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
          userDetailsBody(),
        ],
      ),
    );
  }
}

class userDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          CachedImage(
            user.profilePhoto,
            isRound: true,
            radius: 50,
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).textTheme.headline6.color),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                user.email,
                style:TextStyle(
                  color: Theme.of(context).textTheme.headline6.color
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
