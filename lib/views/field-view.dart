import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:snowscoop/view-models/field-state.dart';
// import 'package:snowscoop/views/widgets/bar-chart.dart';
import 'package:snowscoop/views/widgets/line-chart.dart';
import 'package:snowscoop/views/widgets/time-series-chart.dart';
import 'package:snowscoop/views/widgets/graph-legend.dart';
import 'package:snowscoop/models/enums/current-weather.dart';

import 'package:snowscoop/util/colors.dart' as colors;
import 'package:snowscoop/util/theme/theme-wrapper.dart';
import 'package:snowscoop/util/theme/themes.dart';
import 'package:snowscoop/views/widgets/frosted-container.dart';
import 'package:snowscoop/views/widgets/graph-button.dart';

class FieldView extends FieldState {
  Size _phoneSize;
  double _bodyWidth;
  Widget currentLegend;

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition mapPosition;

  @override
  Widget build(BuildContext context) {
    _phoneSize = MediaQuery.of(context).size;
    _phoneSize =
        Size(_phoneSize.width, _phoneSize.height - 50); // to adjust for appbar
    _bodyWidth = _phoneSize.width * 0.92;
    mapPosition = CameraPosition(
        target: LatLng(widget.field.coords[0], widget.field.coords[1]),
        zoom: 10);

    return new Scaffold(appBar: _appbar(), body: _body());
  }

  /// the appbar for the application
  Widget _appbar() {
    return AppBar(
      title: Text(
        widget.field.title,
        style: Theme.of(context).appBarTheme.textTheme.title,
      ),
      centerTitle: true,
    );
  }


  /// the pages background image.
  /// switches dynamically based on theme context
  /// TODO: move to own widget file
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
        builder: (context, constraints) =>
            Stack(fit: StackFit.expand, children: <Widget>[
              _backgroundImage(),
              new SingleChildScrollView(
                  child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: _phoneSize.height * 0.02),
                  new FrostedContainer(
                      width: _bodyWidth, child: _graphWithButtons()),
                  SizedBox(height: (_phoneSize.height * 0.01)),
                  currentLegend ?? _tempLegend(),
                  SizedBox(height: (_phoneSize.height * 0.01)),
                  new FrostedContainer(
                    width: _bodyWidth,
                    child: map(),
                  ),
                  SizedBox(height: (_phoneSize.height * 0.04)),
                ],
              ))
            ]));
  }

  /// the graph object to be displayed, wrapped in a frosted container 
  /// and with graph switching buttons underneath 
  Widget _graphWithButtons() {
    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        child: new Column(children: <Widget>[
          // SizedBox(height: (_phoneSize.height * 0.02)),
          new Text(
            graphTitle,
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(height: (_phoneSize.height * 0.02)),
          graphContainer(),
          SizedBox(height: (_phoneSize.height * 0.015)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GraphButton(
                label: 'Temperatures',
                altLabel: 'TEMPERATURES',
                selected: selected,
                onPressed: () => switchButton('TEMPERATURES'),
              ),
              GraphButton(
                label: 'Snow / Rain',
                altLabel: 'SNOWRAIN',
                selected: selected,
                onPressed: () => switchButton('SNOWRAIN'),
              )
            ],
          )
        ]));
  }


  // TODO: move to GraphLegend file
  /// the legend to display when viewing temperatures line chart
  Widget _tempLegend() {
    return new Column(
      children: <Widget>[
        new GraphLegendItem(
          label: 'Maximum Temp',
          width: _bodyWidth,
          color: Colors.red,
          trailing: Icon(Icons.trending_up,
              size: _phoneSize.height * 0.04,
              color: Theme.of(context).accentColor),
          onTap: () {
            print('maximum effort');
          },
        ),
        SizedBox(height: (_phoneSize.height * 0.01)),
        new GraphLegendItem(
          label: 'Minimum Temp',
          width: _bodyWidth,
          color: Colors.cyan,
          trailing: Icon(Icons.trending_down,
              size: _phoneSize.height * 0.04,
              color: Theme.of(context).accentColor),
          onTap: () {
            print('mini me');
          },
        ),
        SizedBox(height: (_phoneSize.height * 0.01)),
        new GraphLegendItem(
          label: 'Wind Chill Factor',
          width: _bodyWidth,
          color: Colors.yellow,
          trailing: Icon(Icons.ac_unit,
              size: _phoneSize.height * 0.04,
              color: Theme.of(context).accentColor),
          onTap: () {
            print('chill bruh');
          },
        ),
      ],
    );
  }


  /// the legend to display when viewing snow/rain bar chart
  Widget _snowLegend() {
    return new Column(
      children: <Widget>[
        new GraphLegendItem(
          label: 'Snowfall (cm)',
          width: _bodyWidth,
          color: Colors.blue,
          trailing: Icon(Icons.ac_unit,
              size: _phoneSize.height * 0.04,
              color: Theme.of(context).accentColor),
          onTap: () {
            print('snowrain');
          },
        ),
        SizedBox(height: (_phoneSize.height * 0.01)),
        new GraphLegendItem(
          label: 'Rainfall (mm)',
          width: _bodyWidth,
          color: Colors.red,
          trailing: Icon(Icons.beach_access,
              size: _phoneSize.height * 0.04,
              color: Theme.of(context).accentColor),
          onTap: () {
            print('temps');
          },
        ),
      ],
    );
  }

  // TODO: fix for iOS
  /// the Google Maps map object, wrapped in a container
  Widget map() {
    return new Column(children: <Widget>[
      new Text(
        'Field Location',
        style: Theme.of(context).textTheme.title,
      ),
      SizedBox(height: (_phoneSize.height * 0.02)),
      Container(
          height: 200,
          child: GoogleMap(
            markers: <Marker>{
              Marker(
                markerId: MarkerId(mapPosition.toString()),
                position: mapPosition.target,
              )
            },
            mapType: MapType.normal,
            initialCameraPosition: mapPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ))
    ]);
  }

  /// the container wrapper for our graph.
  /// also builds the graph with selected field
  Widget graphContainer() {
    return new Container(
        // height: (_phoneSize.height * 0.4),
        // width: _phoneSize.width * 0.875,
        decoration: new BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: new ModalProgressHUD(
          inAsyncCall: false,
          opacity: 0,
          child: new Center(
            child:
                new Padding(padding: EdgeInsets.all(10), child: currentGraph),
          ),
        ));
  }


  /// method to update UI based on button switching
  void switchButton(String title) {
    switch (title) {
      case "SNOWRAIN":
        currentGraph = TimeSeriesChart.withField(widget.field);
        currentLegend =_snowLegend();
        setState(() { 
          selected =SelectedButton.SNOWRAIN;
          graphTitle = 'Snow & Rain';
        });
        break;
      case "TEMPERATURES":
        currentGraph = SimpleLineChart.withField(widget.field);
        currentLegend =_tempLegend();
        setState(() { 
          selected =SelectedButton.TEMPERATURES;
          graphTitle = 'Temperatures (\u00B0C)';
        });
        break;
      default:
        break;
    }
  }
}
