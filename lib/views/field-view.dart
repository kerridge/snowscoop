import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:snowscoop/view-models/field-state.dart';
// import 'package:snowscoop/views/widgets/bar-chart.dart';
import 'package:snowscoop/views/widgets/line-chart.dart';
import 'package:snowscoop/views/widgets/time-series-chart.dart';
import 'package:snowscoop/views/widgets/graph-legend.dart';

import 'package:snowscoop/util/colors.dart' as colors;
import 'package:snowscoop/util/theme/theme-wrapper.dart';
import 'package:snowscoop/util/theme/themes.dart';
import 'package:snowscoop/views/widgets/frosted-container.dart';
import 'package:snowscoop/views/widgets/graph-button.dart';

class FieldView extends FieldState {
  Size _phoneSize;
  double _bodyWidth;

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

  Widget _appbar() {
    return AppBar(
      title: Text(
        widget.field.title,
        style: Theme.of(context).textTheme.title,
      ),
      centerTitle: true,
    );
  }

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

                  new GraphLegendItem(
                    label: 'Minimum Temp',
                    width: _bodyWidth,
                    color: Colors.cyan,
                    trailing: 
                      Icon(Icons.trending_down,
                        size: _phoneSize.height * 0.04,
                        color: Theme.of(context).accentColor
                      ),
                    onTap: () {print('hey x');},
                  ),
                  SizedBox(height: (_phoneSize.height * 0.01)),
                  new GraphLegendItem(
                    label: 'Maximum Temp',
                    width: _bodyWidth,
                    color: Colors.red,
                    trailing: 
                      Icon(Icons.trending_up,
                        size: _phoneSize.height * 0.04,
                        color: Theme.of(context).accentColor
                      ),
                    onTap: () {print('hey x');},
                  ),
                  SizedBox(height: (_phoneSize.height * 0.01)),
                  new GraphLegendItem(
                    label: 'Wind Chill Factor',
                    width: _bodyWidth,
                    color: Colors.yellow,
                    trailing: 
                      Icon(Icons.ac_unit,
                        size: _phoneSize.height * 0.04,
                        color: Theme.of(context).accentColor
                      ),
                    onTap: () {print('hey x');},
                  ),

                  SizedBox(height: (_phoneSize.height * 0.02)),

                  new FrostedContainer(
                    width: _bodyWidth,
                    child: map(),
                  ),
                ],
              ))
            ]));
  }

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
}
