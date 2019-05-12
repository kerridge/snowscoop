import 'package:flutter/material.dart';

import 'package:snowscoop/view-models/home-state.dart';
import 'package:snowscoop/views/widgets/line-chart.dart';

import 'package:snowscoop/util/graph-util.dart';
// import 'package:snowscoop/models/enums/current-button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomeView extends HomeState {
  @override
  Widget build(BuildContext context) {
    final Size phoneSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: new Center(
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Container(
                    width: phoneSize.width * 0.95,
                    height: phoneSize.height * 0.90,
                    decoration: new BoxDecoration(
                        color: Color.fromRGBO(13, 13, 14, 50).withOpacity(0.2)),
                    child: new Column(
                      children: <Widget>[
                        SizedBox(height: (phoneSize.height * 0.1)),
                        graphContainer(phoneSize),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            typeButton("RAIN"),
                            typeButton("SNOW"),
                            typeButton("WIND"),
                            typeButton("MIN"),
                            typeButton("MAX"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget typeButton(String title) {
    bool isSelected = false;

    if (selected.toString() == "SelectedButton." + title) {
      isSelected = true;
    }

    return new Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        color: isSelected ? Colors.grey : Color(0xFF0085CA),
        child: new MaterialButton(
          height: 10,
          minWidth: 10,
          child: new Text(title),
          onPressed: () {
            isSelected
              ? print("disabled")
              : switchButton(title);
          },
        ));
  }

  Widget graphContainer(Size phoneSize) {
    return new Container(
      height: (phoneSize.height * 0.45),
      width: phoneSize.width * 0.875,
      decoration: new BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 100),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: new ModalProgressHUD(
        inAsyncCall: scraping,
        opacity: 0,
        child: new Center(child: SimpleLineChart.withCustomData(rain)),
      ),
    );
  }
}
