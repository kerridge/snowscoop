import 'package:flutter/material.dart';

import 'package:snowscoop/view-models/home-state.dart';
import 'package:snowscoop/views/widgets/line-chart.dart';

import 'package:snowscoop/util/graph-util.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomeView extends HomeState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: new ModalProgressHUD(
        inAsyncCall: scraping,
        child: new SimpleLineChart(
          buildSeries(rain),
          animate: false,
        ),
      )
      
       
    );
  }
}