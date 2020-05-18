import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_chatting_app/' 'Theming/ThemeData.dart';
import 'package:video_chatting_app/models/user.dart';
import 'package:video_chatting_app/provider/AppThemeNotifier.dart';
import 'package:video_chatting_app/provider/user_provider.dart';
import 'package:video_chatting_app/resources/update_methods.dart';

class settingsPage extends StatefulWidget with WidgetsBindingObserver {
  @override
  _settingsPageState createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  var _darkTheme = true;
  File imageFile;
  final UpdateMethods _updateMethods = UpdateMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          title: Text('Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0
          ),),

          backgroundColor: Theme.of(context).accentColor,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Container(
              color: Theme.of(context).accentColor,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2 - 325.0),
              child: Container(

               decoration: BoxDecoration(
                   borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(40.0),
                       topRight: Radius.circular(40.0)),
                 color: Theme.of(context).backgroundColor,
               ),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 2 - 100.0),
                      title: GestureDetector(
                        onTap: () => _showImageDialog(userProvider.getUser),
                        child: CircleAvatar(
                          radius: 100.0,
                          backgroundImage: userProvider.getUser.profilePhoto.isEmpty
                              ? AssetImage('assets/no_image.png')
                              : NetworkImage(userProvider.getUser.profilePhoto),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.photo_camera,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Dark Mode'),
                      contentPadding: const EdgeInsets.only(left: 16.0),
                      trailing: Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: _darkTheme,
                          onChanged: (val) {
                            setState(() {
                              _darkTheme = val;
                            });
                            onThemeChanged(val, themeNotifier);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> _pickImage(String action) async {
    File selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery)
        : await ImagePicker.pickImage(source: ImageSource.camera);

    return selectedImage;
  }

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }

  _showImageDialog(User user) {
    return showDialog(
        context: context,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    compressImage();
                    _updateMethods.uploadImageToStorage(imageFile).then((url) {
                      _updateMethods.updatePhoto(url, user.uid).then((v) {
                        Navigator.pop(context);
                      });
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    compressImage();
                    _updateMethods.uploadImageToStorage(imageFile).then((url) {
                      _updateMethods.updatePhoto(url, user.uid).then((v) {
                        Navigator.pop(context);
                      });
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  void compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    Im.copyResize(image);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newim2;
    });
  }
}
