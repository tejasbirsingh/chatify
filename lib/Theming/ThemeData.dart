import 'package:flutter/material.dart';

final darkTheme = ThemeData(
    textSelectionColor: Colors.white,
    appBarTheme: AppBarTheme(
        color: Colors.black26,


    ),
    iconTheme: IconThemeData(
        color: Colors.red,
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
    backgroundColor: Colors.black.withOpacity(0.1),
    accentColor: Colors.red,

    dividerColor: Colors.black12,
);

final lightTheme = ThemeData(
    textSelectionColor: Colors.black,
    appBarTheme: AppBarTheme(
        color: Colors.black.withOpacity(0.6),

    ),
    iconTheme: IconThemeData(
        color: Colors.red,
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
    accentColor: Colors.red,
   
    dividerColor: Colors.white54,
);
