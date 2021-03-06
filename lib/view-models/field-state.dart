import 'package:flutter/material.dart';

import 'package:snowscoop/models/enums/current-weather.dart';
import 'package:snowscoop/models/ski-field.dart';
import 'package:snowscoop/views/field-view.dart';

import 'package:snowscoop/views/widgets/line-chart.dart';
import 'package:snowscoop/views/widgets/time-series-chart.dart';

class FieldPage extends StatefulWidget {
  final Field field;

  FieldPage({@required this.field});

  @override
  FieldView createState() => new FieldView();
}

abstract class FieldState extends State<FieldPage> {
  @override
  FieldPage get widget => super.widget;

  var selected =SelectedButton.TEMPERATURES;
  String graphTitle = 'Temperatures (\u00B0C)';
  Widget currentGraph;
  


  @override
  void initState(){
    super.initState();
    currentGraph=SimpleLineChart.withField(widget.field);
  }
}