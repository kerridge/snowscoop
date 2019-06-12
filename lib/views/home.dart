import 'package:flutter/material.dart';

import 'package:snowscoop/view-models/home-state.dart';
import 'package:snowscoop/views/widgets/line-chart.dart';

import 'package:snowscoop/models/ski-field.dart';
// import 'package:snowscoop/models/enums/current-button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomeView extends HomeState {
  Size _phoneSize;

  List<Color> primaryColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    _phoneSize = MediaQuery.of(context).size;
    _phoneSize = Size(_phoneSize.width, _phoneSize.height - 50); // to adjust for appbar

    return new Scaffold(appBar: _appbar(), body: _body());
  }

  /// Builds the appbar for the page
  Widget _appbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: new AppBar(
        title: new DropdownButton<String>(
          items: skifields.regions
              .map((_region) =>
                  DropdownMenuItem(child: Text(_region), value: _region))
              .toList(),
          onChanged: (String _region) {
            setState(() {
              selectedRegion = _region;
              regionFields = skifields.getFieldsByRegion(selectedRegion);
              updateRegionWeather(regionFields);
            });
          },
          value: selectedRegion,
        ),
      ),
    );
  }

  /// Builds the body of the page
  Widget _body() {
    return new Material(
      color: Colors.green,
      child: SafeArea(
        child: Scaffold(
          body: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: _phoneSize.width * 0.95,
                    height: _phoneSize.height * 0.90,
                    decoration: new BoxDecoration(
                        // color: Color.fromRGBO(1, 1, 1, 50).withOpacity(0.2)),
                        color: Colors.black26),
                    child: new Column(
                      children: <Widget>[
                        SizedBox(height: (_phoneSize.height * 0.02)),
                        new Text(
                          graphTitle,
                          style: new TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: (_phoneSize.height * 0.02)),
                        graphContainer(),
                        SizedBox(height: (_phoneSize.height * 0.015)),
                        new Row(
                          // button row
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _typeButton("RAIN"),
                            _typeButton("SNOW"),
                            _typeButton("CHILL"),
                            _typeButton("MIN"),
                            _typeButton("MAX"),
                          ],
                        ),
                        new Container(
                            height: _phoneSize.height * 0.3,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: regionFields == null ? 0 : regionFields.length * 2,
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildEntireKey(regionFields)[index];
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
    );
  }

  /// Builds a list of graph key widgets to fill our list builder.
  /// Takes a list of `Field` objects
  List<Widget> _buildEntireKey(List<Field> fields) {
    List<Widget> listView = new List();

    for (int i = 0; i < fields.length; i++) {
      Field field = fields[i];
      // spacing
      listView.add(SizedBox(height: (_phoneSize.height * 0.01)));
      // key object
      listView.add(_graphKeyItem(field.title, primaryColors[i]));
    }

    return listView;
  }

  /// A widget to represent a graph key item.
  /// Takes a `String` label and a `Color` to match graph line
  Widget _graphKeyItem(String label, Color color) {
    return new Row(
      // graph key
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Material(
          borderRadius: BorderRadius.circular(10.0),
          shadowColor: Colors.grey,
          elevation: 4.0,
          color: Colors.white,
          child: GestureDetector(
                      child: new Container(
                padding: EdgeInsets.only(left: _phoneSize.width * 0.025),
                height: 50,
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
                            height: 30,
                            width: 30,
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
                            width: _phoneSize.width * 0.60,
                            child: new Text(
                              label,
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
                onTap: () {
                  Navigator.pushNamed(context, '/field-page', arguments: label);
                },
          ),
        ),
      ],
    );
  }

  /// A button widget for switching weather type
  Widget _typeButton(String title) {
    bool isSelected = false;

    if (selected.toString() == "SelectedButton." + title) {
      isSelected = true;
    }

    return new Container(
        width: _phoneSize.width * 0.17,
        child: new Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            shadowColor: Colors.lightBlueAccent.shade100,
            elevation: 5.0,
            color: isSelected ? Colors.blueAccent : Colors.white,
            child: new MaterialButton(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: new Text(title,
                    style: new TextStyle(fontSize: 12),
                    textAlign: TextAlign.center),
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
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: new ModalProgressHUD(
        inAsyncCall: scraping,
        opacity: 0,
        child: new Center(
          child: new Padding(
              padding: EdgeInsets.all(10),
              child: SimpleLineChart.withFieldList(regionFields, selected)),
        ),
      ),
    );
  }
}
