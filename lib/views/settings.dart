import 'package:flutter/material.dart';
import 'package:snowscoop/view-models/settings-state.dart';


class SettingsView extends SettingsState {

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
              child: new Column(children: <Widget>[
            new SwitchListTile(
              value: isDarkSetting,
              onChanged: themeSwitcher,
              activeColor: Theme.of(context).splashColor,
              title: Text(
                'Dark Mode',
                style: Theme.of(context).textTheme.body2,
              ),
            ),
          ])
        )
      )
    );
  }
}
