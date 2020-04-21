import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chatting_app/Screens/SearchPage.dart';

class QuietBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: Colors.redAccent,
          padding: EdgeInsets.symmetric(vertical: 35,horizontal: 25),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
            children: [
              Text("No recent chats",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:30.0
              ),),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Start messaging your family and friends right now",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 30.0,),
              FlatButton(
                color: Colors.redAccent,
                child: Text("Search Users"),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchPage(),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
