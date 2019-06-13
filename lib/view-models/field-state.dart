import 'package:flutter/material.dart';


import 'package:snowscoop/models/ski-field.dart';
import 'package:snowscoop/network/get_field.dart';
import 'package:snowscoop/views/field-view.dart';

class FieldPage extends StatefulWidget {
  final Field field;
  

  FieldPage({@required this.field});

  @override
  FieldView createState() => new FieldView();
}

abstract class FieldState extends State<FieldPage> {
  @override
  FieldPage get widget => super.widget;

  @override
  void initState(){
    super.initState();
  }

}