import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_chatting_app/Screens/Home.dart';
import 'package:video_chatting_app/Screens/Login.dart';
import 'package:video_chatting_app/Screens/SearchPage.dart';
import 'package:video_chatting_app/resources/firebase_repository.dart';

void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseRepository _repository  = FirebaseRepository();
  @override
  Widget build(BuildContext context) {

//    _repository.signOut();
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Chatify',
      initialRoute: "/",
      routes: {
        '/search_page' :(context) => SearchPage()
      },
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _repository.getCurrentUser(),
        builder: (context , AsyncSnapshot<FirebaseUser> snapshot){
            if (snapshot.hasData){
              return HomePage();
            }
            else{
              return LoginPage();
            }
        },
      )
    );
  }
}
