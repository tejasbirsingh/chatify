import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chatting_app/Screens/ChatScreen/widgets/userDetailsContainer.dart';
import 'package:video_chatting_app/provider/user_provider.dart';
import 'package:video_chatting_app/utils/utilities.dart';

class UserCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60.0), color: Colors.white),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              Utils.getInitials(userProvider.getUser.name),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontSize: 13,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                  color: Colors.green),
            ),
          )
        ],
      ),
    );
  }
}
