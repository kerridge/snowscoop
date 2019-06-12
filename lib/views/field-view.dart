import 'package:flutter/material.dart';


import 'package:snowscoop/view-models/field-state.dart';

class FieldView extends FieldState {
  
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.blue,
      child: Text(widget.field),
    );
  }
}