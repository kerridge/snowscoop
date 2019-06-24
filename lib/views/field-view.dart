import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:snowscoop/view-models/field-state.dart';
import 'package:snowscoop/views/widgets/bar-chart.dart';
import 'package:snowscoop/views/widgets/line-chart.dart';
import 'package:snowscoop/views/widgets/time-series-chart.dart';

class FieldView extends FieldState {
  Size _phoneSize;

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition mapPosition;

  @override
  Widget build(BuildContext context) {
    _phoneSize = MediaQuery.of(context).size;
    _phoneSize =
        Size(_phoneSize.width, _phoneSize.height - 50); // to adjust for appbar
    mapPosition = CameraPosition(
        target: LatLng(widget.field.coords[0], widget.field.coords[1]),
        zoom: 10);

    return new Scaffold(appBar: _appbar(), body: _body());
  }

  Widget _appbar() {
    return AppBar(
      title: Text(widget.field.title),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Container(
              width: _phoneSize.width * 0.95,
              // height: _phoneSize.height * 0.90,
              color: Colors.black26,
              child: Column(
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: _phoneSize.height*0.02),
                    child: Text(
                      'A Graph that needs a title',
                      style: new TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                    ),
                  
                  //Graph
                  graphContainer(),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: _phoneSize.height*0.015),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _typeButton("Temps"),
                        _typeButton("Rain/Snow"),
                      ],
                    ),
                  ),

                  //Map
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: new Text(
                          'Field location',
                          style: new TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(height: 200, child: map()),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _typeButton(String title) {
    bool isSelected = false;

    if (tempsSelected == (title == "Temps")) {
      isSelected = true;
    }

    return new Container(
        width: _phoneSize.width * 0.3,
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
                    style: new TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
              ),
              onPressed: () {
                isSelected ? print("disabled") : setState((){tempsSelected = !tempsSelected;});
              },
            )));
  }

  Widget map() {
    return GoogleMap(
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
    );
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
          inAsyncCall: false,
          opacity: 0,
          child: new Center(
            child: new Padding(
              padding: EdgeInsets.all(10),
              child: tempsSelected ? SimpleLineChart.withField(widget.field) : TimeSeriesChart.withField(widget.field),
            ),
          ),
        ));
  }
}
