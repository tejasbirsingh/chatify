import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_chatting_app/Screens/Home.dart';
import 'package:video_chatting_app/resources/firebase_repository.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseRepository _repository = FirebaseRepository();
  bool isLogin=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: <Widget>[
          Center(child: loginButton()),
          isLogin ?
              Center(
                child: CircularProgressIndicator(),
              ):
              Container()

        ],
      ),
    );
  }

  Widget loginButton() {
    return FlatButton(
      padding: EdgeInsets.all(40.0),
      child: Text(
        'Login',
        style: TextStyle(
            fontSize: 30.0, fontWeight: FontWeight.w900, letterSpacing: 1.2),
      ),
      onPressed: ()=>performLogin(),
    );
  }

  void performLogin() {
    setState(() {
      isLogin = true;
    });
    _repository.signIn().then((FirebaseUser user) {
      if (user != null){
        authenticateUser(user);
      }
      else{
        print('Error!!');
      }
    });
  }

  void authenticateUser(FirebaseUser user){

      _repository.authenticateUser(user).then((isNewUser) {
        setState(() {
          isLogin = false;
        });
        if(isNewUser){
          _repository.addDataToDb(user).then((value){
            Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context){
              return HomePage();
            }));
          });
        }

      });
  }
}
