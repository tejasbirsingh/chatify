

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chatting_app/Screens/call_screens/Call_page.dart';
import 'package:video_chatting_app/models/call.dart';
import 'package:video_chatting_app/models/user.dart';
import 'package:video_chatting_app/resources/call_method.dart';

class CallUtils{
  static final CallMethods callMethods = CallMethods();

  static dial({User from , User to , context}) async{
    Call call = Call(  
      callerId : from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverName: to.name,
      receiverId: to.uid,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);
    call.hasDialled = true;

    if(callMade)
    {

     Navigator.push(context,
         MaterialPageRoute(
       builder: (context) => CallPage(call: call,)
     ));

    }
}
}