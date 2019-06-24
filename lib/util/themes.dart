import 'package:flutter/material.dart';

ThemeData darkTheme = new ThemeData(
  // 
  primaryColor: Colors.black,
  // color of graph and buttons
  canvasColor: Color.fromRGBO(39, 39, 39, 1),
  buttonColor: Color.fromRGBO(39, 39, 39, 1),
  // main accent
  accentColor: Colors.white,
  disabledColor: Color.fromRGBO(1, 16, 110, 1),
  fontFamily: 'Signika',

  textTheme: TextTheme(
    // graph title
    title: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
    body2: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
    button: TextStyle(fontSize: 12, color: Colors.white)
  )
);