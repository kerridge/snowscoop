import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:snowscoop/view-models/field-state.dart';

class FieldView extends FieldState {

  
  Completer<GoogleMapController> _controller = Completer();
static final CameraPosition mapPosition =CameraPosition(
  target: LatLng(-44.873106, 168.948808),
  zoom: 10
);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(widget.field),
               Center(
                 child: Container(
                  height: 400,
                  width: 250,
                  child: map()
              ),
               )
              
      
            ],
          ),
    );
    }

    Widget map(){
      return GoogleMap(
          markers: <Marker> {
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
}