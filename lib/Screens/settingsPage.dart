import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_chatting_app/Theming/ThemeData.dart';
import 'package:video_chatting_app/provider/AppThemeNotifier.dart';

class settingsPage extends StatefulWidget {
  @override
  _settingsPageState createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  var _darkTheme = true;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SafeArea(
      child: Scaffold(


appBar: AppBar(
  title: Text('Settings'),
),
        body: ListView(
          children: [
            ListTile(
              title: Text('Dark Mode'),
              contentPadding: const EdgeInsets.only(left: 16.0),
              trailing: Transform.scale(scale: 0.8,
              child: Switch(

                value: _darkTheme,
                onChanged: (val){
                  setState(() {
                    _darkTheme= val;
                  });
                  onThemeChanged(val , themeNotifier);
                },
              ),),
            )
          ],
        ),
      ),
    );
  }
  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }
}
