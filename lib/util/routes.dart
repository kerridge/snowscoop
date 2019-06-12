import 'package:flutter/material.dart';
import 'package:snowscoop/view-models/home-state.dart';
import 'package:snowscoop/view-models/field-state.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Home());
    case '/field-page':
      String field = settings.arguments;
      return MaterialPageRoute(builder: (context) => FieldPage(field: field));
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}
