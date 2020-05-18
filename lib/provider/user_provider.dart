import 'package:flutter/cupertino.dart';
import 'package:video_chatting_app/models/user.dart';
import 'package:video_chatting_app/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User _user;
  AuthMethods _authMethods = AuthMethods();

  User get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
