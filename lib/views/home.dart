import 'package:flutter/material.dart';
import 'package:snowscoop/models/all_fields.dart';

import 'package:snowscoop/view-models/home-state.dart';
import 'package:snowscoop/views/widgets/line-chart.dart';

import 'package:snowscoop/models/ski-field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:snowscoop/views/widgets/frosted-container.dart';
import 'package:snowscoop/views/widgets/graph-button.dart';
import 'package:snowscoop/views/widgets/graph-legend.dart';

import 'package:snowscoop/util/colors.dart' as colors;
import 'package:snowscoop/util/theme/theme-wrapper.dart';
import 'package:snowscoop/util/theme/themes.dart';

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

  /// the app drawer menu
  Widget _drawer() {
    double _settingsHeight = 70;

    return new LayoutBuilder(
        builder: (context, constraints) => Drawer(
              child: new Stack(children: <Widget>[
                Column(children: <Widget>[
                  // for every tile in field tiles insert them
                  for (Widget tile in _fieldTiles()) tile,
                  SizedBox(
                    height: 20,
                  ),
                ]),
                Positioned(
                  width: _phoneSize.width * 0.73,
                  top: constraints.maxHeight - _settingsHeight,
                  left: constraints.minWidth,
                  child: ListTile(
                    title: Text(
                      '\t\tSettings',
                      style: Theme.of(context).textTheme.title,
                      // textAlign: TextAlign.center,
                    ),
                    trailing: Icon(Icons.settings,
                        size: 30, color: Theme.of(context).accentColor),
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                  ),
                )
              ]),
            ));
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
            icon: new Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
          title: Text(
            'Snow Scoop',
            style: Theme.of(context).appBarTheme.textTheme.title,
          )),
    );
  }

  // TODO: move to its own widget file

  /// These are the tiles added to the app drawer
  List<Widget> _fieldTiles() {
    List<Widget> tiles = new List<Widget>();

    tiles.add(new SizedBox(
      height: 40,
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
            style: selected
                ? Theme.of(context).textTheme.body1
                : Theme.of(context).textTheme.body2,
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

  /// the pages background image.
  /// switches dynamically based on theme context
  Widget _backgroundImage() {
    String bgImage = '';

    // a check to see if we are currently in dark mode
    CustomTheme.instanceOf(context).themeKey == MyThemeKeys.DARK
        ? bgImage = 'images/bgs/night-lifts.jpg'
        : bgImage = 'images/bgs/field.jpg';

    return new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage(bgImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// the body of our scaffold
  Widget _body() {
    return new LayoutBuilder(
        builder: (context, constraints) => Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _backgroundImage(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FrostedContainer(
                        width: _bodyWidth, child: _graphWithButtons()),
                    _legendList(selectedFields),
                  ],
                )
              ],
            ));
  }

  /// the graph object to be displayed, wrapped in a frosted container
  /// and with graph switching buttons underneath
  Widget _graphWithButtons() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: new Column(
        children: <Widget>[
          new Text(
            graphTitle,
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(height: (_phoneSize.height * 0.02)),
          _graphContainer(),
          SizedBox(height: (_phoneSize.height * 0.015)),
          // button row
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new GraphButton(
                  label: 'RAIN',
                  selected: selected,
                  onPressed: (() => switchButton('RAIN'))),
              new GraphButton(
                  label: 'SNOW',
                  selected: selected,
                  onPressed: (() => switchButton('SNOW'))),
              new GraphButton(
                  label: 'CHILL',
                  selected: selected,
                  onPressed: (() => switchButton('CHILL'))),
              new GraphButton(
                  label: 'MIN',
                  selected: selected,
                  onPressed: (() => switchButton('MIN'))),
              new GraphButton(
                  label: 'MAX',
                  selected: selected,
                  onPressed: (() => switchButton('MAX'))),
            ],
          ),
        ],
      ),
    );
  }

  /// a list of `GraphLegendItem` to be built 
  /// based on the list of ski fields passed
  Widget _legendList(List<Field> fields) {
    List<Widget> legendItems = new List();

    for (int i = 0; i < fields.length; i++) {
      Field field = fields[i];
      // spacing
      legendItems.add(SizedBox(height: (_phoneSize.height * 0.01)));

      // legend object
      legendItems.add(GraphLegendItem(
        label: field.title,
        color: colors.graphColors[i],
        width: _bodyWidth,
        trailing: Icon(Icons.keyboard_arrow_right,
            size: _phoneSize.height * 0.04,
            color: Theme.of(context).accentColor),
        onTap: () {
          Navigator.pushNamed(context, '/field-page', arguments: field);
        },
      ));
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

  /// the container wrapper for our graph.
  /// also builds the graph with selected fields
  Widget _graphContainer() {
    return new Container(
      height: (_phoneSize.height * 0.37),
      decoration: new BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: new ModalProgressHUD(
        inAsyncCall: inAsyncCall,
        opacity: 0,
        child: new Center(
          child: new Padding(
              padding: EdgeInsets.all(10),
              child: SimpleLineChart.withFieldList(
                  selectedFields, selected, fillArea)),
        ),
      ),
    );
  }
}
