import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snowscoop/views/home.dart'
// import 'package:snowscoop/util/scrape-field.dart' as scraper;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snow Scoop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Signika',
        
      ),
      home: new Home(),
      routes: routes,
    );
  }
}
