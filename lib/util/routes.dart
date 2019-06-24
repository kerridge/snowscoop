import 'package:flutter/material.dart';
import 'package:snowscoop/models/ski-field.dart';
import 'package:snowscoop/view-models/home-state.dart';
import 'package:snowscoop/view-models/field-state.dart';
import 'package:snowscoop/view-models/settings-state.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Home());
    case '/field-page':
      Field field = settings.arguments;
      return MaterialPageRoute(builder: (context) => FieldPage(field: field));
    case '/settings':
      return MaterialPageRoute(builder: (context) => Settings());
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}
