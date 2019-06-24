import 'package:flutter/material.dart';
import 'package:snowscoop/models/all_fields.dart';

import 'package:snowscoop/view-models/home-state.dart';
import 'package:snowscoop/views/widgets/line-chart.dart';

import 'package:snowscoop/models/ski-field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:snowscoop/views/widgets/frosted-container.dart';
import 'package:snowscoop/util/colors.dart' as colors;

class HomeView extends HomeState {
  Size _phoneSize;
  double _bodyWidth;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _phoneSize = MediaQuery.of(context).size;
    _phoneSize =
        Size(_phoneSize.width, _phoneSize.height - 50); // to adjust for appbar
    _bodyWidth = _phoneSize.width * 0.92;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: _appbar(),
      body: _body(),
      drawer: _drawer(),
    );
  }

  Widget _drawer() {
    return new Drawer(
      child: ListView(
        children: _fieldTiles(),
      ),
    );
  }

  // move to its own file
  List<ListTile> _fieldTiles() {
    List<ListTile> tiles = new List<ListTile>();

    tiles.add(ListTile(
      title: Text('Please select the fields to view'),
    ));
    for (Region region in skifields.regions) {
      tiles.add(ListTile(
        title: Text(
          region.region,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ));
      for (Field field in region.fields) {
        bool selected = false;
        if (selectedFields.contains(field)) selected = true;
        tiles.add(ListTile(
          title: Text('\t\t${field.title}'),
          onTap: () {
            fieldSelected(field);
          },
          selected: selected,
        ));
      }
    }
    return tiles;
  }

  /// Builds the appbar for the page
  Widget _appbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: new AppBar(
          backgroundColor: Colors.black,
          leading: new IconButton(
            iconSize: 30,
            icon: new Icon(Icons.landscape),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
          title: Text(
            'Snow Scoop',
          )),
    );
  }

  Widget _backgroundImage() {
    return new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage('images/bgs/field.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _body() {
    return new LayoutBuilder(
      builder: (context, constraints) =>
        Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _backgroundImage(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FrostedContainer(
                  width: _bodyWidth,
                  child: _graphWithButtons()
                ),
                _legendList(selectedFields),
              ],
            )
          ],
        )
     );
  }

  Widget _graphWithButtons() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: new Column(
        children: <Widget>[
          // SizedBox(height: (_phoneSize.height * 0.02)),
          new Text(
            graphTitle,
            style: new TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: (_phoneSize.height * 0.02)),
          graphContainer(),
          SizedBox(height: (_phoneSize.height * 0.015)),
          new Row(
            // button row
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _typeButton("RAIN"),
              _typeButton("SNOW"),
              _typeButton("CHILL"),
              _typeButton("MIN"),
              _typeButton("MAX"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendList(List<Field> fields) {
    List<Widget> legendItems = new List();

    for (int i = 0; i < fields.length; i++) {
      Field field = fields[i];
      // spacing
      legendItems.add(SizedBox(height: (_phoneSize.height * 0.01)));
      // legend object
      legendItems.add(_graphLegendItem(field, colors.graphColors[i]));
    }

    return new Container(
        height: _phoneSize.height * 0.35,
        width: _bodyWidth,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: selectedFields == null ? 0 : selectedFields.length * 2,
            itemBuilder: (BuildContext context, int index) {
              return legendItems[index];
            }));
  }

  /// A widget to represent a graph legend item.
  /// Takes a `String` label and a `Color` to match graph line
  Widget _graphLegendItem(Field field, Color color) {
    return FrostedContainer(
      width: _bodyWidth,
      child: GestureDetector(
        child: new Container(
            child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Column(
              // colored square
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Material(
                  borderRadius: BorderRadius.circular(8.0),
                  color: color,
                  child: new Container(
                    height: _phoneSize.width * 0.07,
                    width: _phoneSize.width * 0.07,
                  ),
                )
              ],
            ),
            SizedBox(width: (_phoneSize.width * 0.01)),
            new Column(
                // field name
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: _phoneSize.width * 0.6,
                    child: new Text(
                      field.title,
                      style: new TextStyle(
                          fontSize: 20,
                          // color: ,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ]),
            new Column(
              // arrow icon
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.keyboard_arrow_right,
                    size: _phoneSize.height * 0.04),
              ],
            ),
          ],
        )),
        onTap: () {
          Navigator.pushNamed(context, '/field-page', arguments: field);
        },
      ),
    );
  }

  /// A button widget for switching weather type
  Widget _typeButton(String title) {
    bool isSelected = false;

    if (selected.toString() == "SelectedButton." + title) {
      isSelected = true;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: new Container(
            // width: _phoneSize.width * 0.17,
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
                ))),
      ),
    );
  }

  Widget graphContainer() {
    return new Container(
      height: (_phoneSize.height * 0.36),
      // width: _phoneSize.width * 0.875,
      decoration: new BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.75),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: new ModalProgressHUD(
        inAsyncCall: scraping,
        opacity: 0,
        child: new Center(
          child: new Padding(
              padding: EdgeInsets.all(10),
              child: SimpleLineChart.withFieldList(selectedFields, selected)),
        ),
      ),
    );
  }
}
