import 'package:flutter/material.dart';
import 'package:video_chatting_app/Screens/call_screens/Call_page.dart';
import 'package:video_chatting_app/models/call.dart';
import 'package:video_chatting_app/resources/call_method.dart';
import 'package:video_chatting_app/utils/permissions.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods =CallMethods();

  PickupScreen({
    @required this.call
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Call Incoming",
              style: TextStyle(
                color: Colors.green,
                fontSize: 30.0
              ),
                ),
            SizedBox(
              height: 50.0,
            ),
            Image.network(
              call.callerPic,
              height: 150,
              width: 150,
            ),
            SizedBox(height: 15,),
            Text(
              call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            SizedBox(height: 75,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async{
                    await callMethods.endCall(call : call);
                  },
                ),
                SizedBox(
                  width: 25,
                ),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: ()  async => await Permissions
                    .cameraAndMicrophonePermissionsGranted() ?


                    Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => CallPage(call :call)
                    )) : {}

                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
