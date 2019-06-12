import 'package:flutter/material.dart';


import 'package:snowscoop/models/ski-field.dart';
import 'package:snowscoop/views/field-view.dart';

class FieldPage extends StatefulWidget {
  final String field;

  FieldPage({@required this.field});

  @override
  FieldView createState() => new FieldView();
}

abstract class FieldState extends State<FieldPage> {

  @override
  void initState(){
    super.initState();
  }
}