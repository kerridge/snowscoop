import 'package:flutter/material.dart';
import 'package:snowscoop/views/settings.dart';

import 'package:snowscoop/util/theme/theme-wrapper.dart';
import 'package:snowscoop/util/theme/themes.dart';

class Settings extends StatefulWidget {
  @override
  SettingsView createState() => new SettingsView();
}

abstract class SettingsState extends State<Settings> {

  /// changes the app theme based on key given
  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  var isDarkSetting = true;

  /// takes result of settings switch and updates app theme accordingly
  void themeSwitcher(bool value) {
    !value 
    ? _changeTheme(context, MyThemeKeys.LIGHT)
    : _changeTheme(context, MyThemeKeys.DARK);

    setState(() => isDarkSetting = value);
  }

  @override
  void initState() {
    super.initState();
  }
}