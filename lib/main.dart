import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snowscoop/util/routes.dart';

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
      onGenerateRoute: generateRoute,
    );
  }
}
