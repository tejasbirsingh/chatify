import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chatting_app/models/user.dart';
import 'package:video_chatting_app/provider/user_provider.dart';

class userProfile extends StatefulWidget {
  final User currUser;

  const userProfile({Key key, this.currUser}) : super(key: key);
  @override
  _userProfileState createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body:

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2 - 200.0,
                    width: MediaQuery.of(context).size.width - 20.0,
                    child: Image.network(
                      widget.currUser.profilePhoto ?? "",
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 20.0,),
                field(widget.currUser.name, 'Name'),
                  SizedBox(height: 20.0,),
                  field(widget.currUser.email, 'Email')
                ],
              ),
            )

      ),
    );
  }

  field(String name, String field){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold
        ),),
        SizedBox(height: 10.0,),
        Text(name,
        style: TextStyle(
          fontSize: 18.0,


        ),)
      ],
    );
  }
}
