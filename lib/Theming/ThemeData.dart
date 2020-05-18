import 'package:flutter/material.dart';

final darkTheme = ThemeData(
    textSelectionColor: Colors.white,
    appBarTheme: AppBarTheme(
        color: Colors.black26,


    ),
    iconTheme: IconThemeData(
        color: Colors.white54,
        size: 30.0
    ),
    textTheme: TextTheme(
        headline6: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
        )
    ),
    primarySwatch: Colors.red,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: Colors.black,
    accentColor: Colors.red.shade800,

    dividerColor: Colors.black12,
);

final lightTheme = ThemeData(
    textSelectionColor: Colors.black,
    appBarTheme: AppBarTheme(


    ),
    iconTheme: IconThemeData(
        color: Colors.white,
        size: 30.0
    ),
    textTheme: TextTheme(
        headline6: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
        )
    ),
    primarySwatch: Colors.red,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    accentColor: Colors.redAccent,
   
    dividerColor: Colors.white54,
);
