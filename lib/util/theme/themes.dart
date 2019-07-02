import 'package:flutter/material.dart';

enum MyThemeKeys { LIGHT, DARK }

class Themes {
  

  static ThemeData lightTheme = new ThemeData(
      //
      primaryColor: Colors.white,
      splashColor: Colors.deepPurpleAccent,
      appBarTheme: AppBarTheme(
        color: Colors.deepPurple[400],
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontFamily: '.SF UI Display',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.35,
          )
        )
      ),

      // color of graph
      canvasColor: Color.fromRGBO(255, 255, 255, 1),
      // buttons
      buttonColor: Color.fromRGBO(255, 255, 255, 1),
      // main accent
      accentColor: Colors.black,
      // selected buttons
      disabledColor: Colors.deepPurple[200],

      fontFamily: 'Signika',
      textTheme: TextTheme(
        // graph title
        title: TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        body1: TextStyle(
            fontSize: 20, color: Colors.blue, fontWeight: FontWeight.w400),
        body2: TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400),
        button: TextStyle(fontSize: 12, color: Colors.black),
      ));


  static ThemeData darkTheme = new ThemeData(
      // 
      primaryColor: Colors.black,
      splashColor: Colors.pink,
      appBarTheme: AppBarTheme(
        color: Colors.black,
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
            fontFamily: '.SF UI Display',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.35,
          )
        )
      ),

      // color of graph
      canvasColor: Color.fromRGBO(39, 39, 39, 1),
      // color of buttons
      buttonColor: Color.fromRGBO(39, 39, 39, 1),
      // main accent
      accentColor: Colors.white,
      // selected button color
      disabledColor: Color.fromRGBO(1, 16, 110, 1),


      fontFamily: 'Signika',
      textTheme: TextTheme(
        // graph title
        title: TextStyle(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        body1: TextStyle(
            fontSize: 20, color: Colors.blue, fontWeight: FontWeight.w400),
        body2: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
        button: TextStyle(fontSize: 12, color: Colors.white),
      ));


    static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
      switch (themeKey) {
        case MyThemeKeys.LIGHT:
          return lightTheme;
        case MyThemeKeys.DARK:
          return darkTheme;
        default:
          return darkTheme;
      }
    }
}
