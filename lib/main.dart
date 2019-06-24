import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snowscoop/util/routes.dart';
import 'package:snowscoop/util/theme/theme-wrapper.dart';
import 'package:snowscoop/util/theme/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  // check the theme before initializing app
  MyThemeKeys _theme = (_prefs.getBool("isDark") ?? true)
    ? MyThemeKeys.DARK 
    : MyThemeKeys.LIGHT;

  runApp(
    CustomTheme(
      initialThemeKey: _theme,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snow Scoop',
      theme: CustomTheme.of(context),
      onGenerateRoute: generateRoute,
    );
  }
}
