import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_chatting_app/Screens/Home.dart';
import 'package:video_chatting_app/Screens/Login.dart';
import 'package:video_chatting_app/Screens/SearchPage.dart';
import 'package:video_chatting_app/Screens/splashScreen.dart';
import 'package:video_chatting_app/Theming/ThemeData.dart';
import 'package:video_chatting_app/constants/string.dart';
import 'package:video_chatting_app/provider/AppThemeNotifier.dart';
import 'package:video_chatting_app/provider/image_upload_provider.dart';
import 'package:video_chatting_app/provider/user_provider.dart';
import 'package:video_chatting_app/resources/auth_methods.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    SharedPreferences.getInstance().then((prefs) {
      var darkModeOn = prefs.getBool('darkMode') ?? true;
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
          child: MyApp(),
        ),
      );
    });
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthMethods _authMethods = AuthMethods();
  final db = Firestore.instance;

  _updateState(s) async {
    FirebaseUser userId = await _authMethods.getCurrentUser();
    await db
        .collection(user_collection)
        .document(userId.uid)
        .updateData({'state': s});
  }

  @override
  void initState() {
    super.initState();
    _updateState(1);
  }

  @override
  void dispose() {
    super.dispose();
    _updateState(3);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ImageUploadProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
        ],
        child: MaterialApp(
            theme: themeNotifier.getTheme(),
            darkTheme: darkTheme,
            title: 'Chatify',
            initialRoute: "/",
            routes: {'/search_page': (context) => SearchPage(),
            '/home_page' : (context) => HomePage()},
            debugShowCheckedModeBanner: false,
            home: FutureBuilder(
              future: _authMethods.getCurrentUser(),
              builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.hasData) {
                  return SplashScreen();
                } else {
                  return LoginPage();
                }
              },
            )));
  }
}
