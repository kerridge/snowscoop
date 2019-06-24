import 'package:flutter/material.dart';
import 'package:snowscoop/models/all_fields.dart';

import 'package:snowscoop/view-models/home-state.dart';
import 'package:snowscoop/views/widgets/line-chart.dart';

import 'package:snowscoop/models/ski-field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:snowscoop/views/widgets/frosted-container.dart';
import 'package:snowscoop/views/widgets/graph-button.dart';
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


  /// Builds the appbar for the page
  Widget _appbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: new AppBar(
          backgroundColor: Theme.of(context).appBarTheme.color,
          centerTitle: true,

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
          style: Theme.of(context).textTheme.title,
        ),
      ));
      for (Field field in region.fields) {
        bool selected = false;
        if (selectedFields.contains(field)) selected = true;
        tiles.add(ListTile(
          title: Text(
            '\t\t${field.title}',
            style: selected ? Theme.of(context).textTheme.body1 : Theme.of(context).textTheme.body2,
          ),
          onTap: () {
            fieldSelected(field);
          },
          selected: selected,
          trailing: selected 
          ? Icon(
            Icons.check,
            size: 20,
            color: Theme.of(context).accentColor,
          ) 
          : null,
        ));
      }
    }
    return tiles;
  }


  Widget _backgroundImage() {
    return new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage('images/bgs/night-lifts.jpg'),
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
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(height: (_phoneSize.height * 0.02)),
          graphContainer(),
          SizedBox(height: (_phoneSize.height * 0.015)),
          // button row
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new GraphButton(
                label: 'RAIN',
                selected: selected,
                onPressed: (() =>  switchButton('RAIN'))
              ),
              new GraphButton(
                label: 'SNOW',
                selected: selected,
                onPressed: (() => switchButton('SNOW'))
              ),
              new GraphButton(
                label: 'CHILL',
                selected: selected,
                onPressed: (() => switchButton('CHILL'))
              ),
              new GraphButton(
                label: 'MIN',
                selected: selected,
                onPressed: (() => switchButton('MIN'))
              ),
              new GraphButton(
                label: 'MAX',
                selected: selected,
                onPressed: (() => switchButton('MAX'))
              ),
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
        height: _phoneSize.height * 0.38,
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
                      style: Theme.of(context).textTheme.body2
                    ),
                  ),
                ]),
            new Column(
              // arrow icon
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.keyboard_arrow_right,
                    size: _phoneSize.height * 0.04,
                    color: Theme.of(context).accentColor
                ),
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


  Widget graphContainer() {
    return new Container(
      height: (_phoneSize.height * 0.36),
      // width: _phoneSize.width * 0.875,
      decoration: new BoxDecoration(
        color: Theme.of(context).canvasColor,
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
