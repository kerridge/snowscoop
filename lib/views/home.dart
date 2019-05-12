import 'package:flutter/material.dart';

import 'package:snowscoop/view-models/home-state.dart';
import 'package:snowscoop/views/widgets/line-chart.dart';

import 'package:snowscoop/util/graph-util.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomeView extends HomeState {
  @override
  Widget build(BuildContext context) {
    final Size phoneSize = MediaQuery.of(context).size;

    return Scaffold(
      body: new Center(
        widthFactor: phoneSize.width * 0.8,
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  width: phoneSize.width * 0.95,
                  height: phoneSize.height * 0.95,
                  decoration: new BoxDecoration(
                      color: Color.fromRGBO(13, 13, 14, 50).withOpacity(0.2)),
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      graphContainer(phoneSize),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget graphContainer(Size phoneSize) {
    return new Container(
      height: (phoneSize.height * 0.45),
      width: phoneSize.width * 0.875,
      decoration: new BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 50),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: new ModalProgressHUD(
        inAsyncCall: scraping,
        child: new Center(child: SimpleLineChart.withCustomData(rain)),
      ),
    );
  }
}
