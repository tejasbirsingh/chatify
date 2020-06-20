



import 'package:flutter/material.dart';
import 'package:video_chatting_app/models/log.dart';
import 'package:video_chatting_app/resources/local_database/repository/log_repository.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: FlatButton(
          child: Text("Click Me"),
          onPressed: (){
            LogRepository.init(isHive: false);
            LogRepository.addLogs(Log());
          },
        ),
      ),
    );
  }
}
