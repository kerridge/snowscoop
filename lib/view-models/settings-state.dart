import 'package:flutter/material.dart';
import 'package:snowscoop/views/settings.dart';

import 'package:snowscoop/util/theme/theme-wrapper.dart';
import 'package:snowscoop/util/theme/themes.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  SettingsView createState() => new SettingsView();
}

abstract class SettingsState extends State<Settings> {

  /// changes the app theme based on key given
  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  // default to dark theme
  var isDarkSetting = true;

  /// takes result of settings switch and updates app theme accordingly
  void themeSwitcher(bool value) async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    
    !value 
    ? _changeTheme(context, MyThemeKeys.LIGHT)
    : _changeTheme(context, MyThemeKeys.DARK);

    setState(() => isDarkSetting = value);

    
    _prefs.setBool('isDark', isDarkSetting);
  }

  @override
  void initState() {
    super.initState();

    getSettings().then((result){
      // after we get our settings from cache
    });
  }

  // async call to get user's settings from cache
  Future getSettings() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() => isDarkSetting =_prefs.getBool('isDark') ?? true);
  }
}