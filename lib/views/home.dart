import 'package:flutter/material.dart';

import 'package:snowscoop/view-models/home-state.dart';
import 'package:snowscoop/views/widgets/line-chart.dart';

import 'package:snowscoop/util/graph-util.dart';
import 'package:snowscoop/models/ski-field.dart';
// import 'package:snowscoop/models/enums/current-button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomeView extends HomeState {
  Size _phoneSize;

  List<Color> primaryColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
  ];
  @override
  Widget build(BuildContext context) {
    _phoneSize = MediaQuery.of(context).size;
    // var entireKey = _buildEntireKey(otago);

    // return new Scaffold(

    // );
    return new Material(
      color: Colors.green,
      child: SafeArea(
        child: Scaffold(
          body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: _phoneSize.width * 0.95,
                      height: _phoneSize.height * 0.90,
                      decoration: new BoxDecoration(
                          color:
                              Color.fromRGBO(13, 13, 14, 50).withOpacity(0.2)),
                      child: new Column(
                        children: <Widget>[
                          SizedBox(height: (_phoneSize.height * 0.08)),
                          graphContainer(),
                          SizedBox(height: (_phoneSize.height * 0.015)),
                          new Row(
                            // button row
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              typeButton("RAIN"),
                              typeButton("SNOW"),
                              typeButton("CHILL"),
                              typeButton("MIN"),
                              typeButton("MAX"),
                            ],
                          ),
                          new Container(
                              height: _phoneSize.height * 0.3,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: otago == null ? 0 : otago.length * 2,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _buildEntireKey(otago)[index];
                                  })),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEntireKey(List<Field> fields) {
    List<Widget> listView = new List();

    for (int i = 0; i < fields.length; i++) {
      Field field = fields[i];
      // spacing
      listView.add(SizedBox(height: (_phoneSize.height * 0.01)));
      // key object
      listView.add(graphKeyItem(field.title, primaryColors[i]));
    }

    return listView;
  }

  Widget graphKeyItem(String title, var color) {
    return new Row(
      // graph key
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Material(
          borderRadius: BorderRadius.circular(10.0),
          shadowColor: Colors.grey,
          elevation: 4.0,
          color: Colors.white,
          child: new Container(
              padding: EdgeInsets.only(left: _phoneSize.width * 0.015),
              height: _phoneSize.height * 0.065,
              width: _phoneSize.width * 0.875,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Column(
                    // colored square
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: color,
                        child: new Container(
                          height: _phoneSize.height * 0.045,
                          width: _phoneSize.width * 0.075,
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: (_phoneSize.width * 0.04)),
                  new Column(
                      // field name
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          width: _phoneSize.width * 0.6,
                          child: new Text(
                            title,
                            style: new TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ]),
                  new Column(
                    // arrow right
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.keyboard_arrow_right,
                          size: _phoneSize.height * 0.06),
                    ],
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget typeButton(String title) {
    bool isSelected = false;

    if (selected.toString() == "SelectedButton." + title) {
      isSelected = true;
    }

    return new Container(
        width: _phoneSize.width * 0.17,
        child: new Material(
            borderRadius: BorderRadius.circular(10.0),
            shadowColor: Colors.lightBlueAccent.shade100,
            elevation: 5.0,
            color: isSelected ? Colors.grey : Color(0xFF0085CA),
            child: new MaterialButton(
              child: new Text(
                title,
                style: new TextStyle(fontSize: 12),
              ),
              onPressed: () {
                isSelected ? print("disabled") : switchButton(title);
              },
            )));
  }

  Widget graphContainer() {
    return new Container(
      height: (_phoneSize.height * 0.4),
      width: _phoneSize.width * 0.875,
      decoration: new BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 100),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: new ModalProgressHUD(
        inAsyncCall: scraping,
        opacity: 0,
        child: new Center(
          child: new Padding(
              padding: EdgeInsets.all(10),
              child: SimpleLineChart.withFieldList(otago, selected)),
        ),
      ),
    );
  }
}
